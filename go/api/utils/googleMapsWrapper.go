package utils

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/spf13/viper"
)

type RequestBody struct {
	TextQuery string `json:"textQuery"`
	PageSize  int    `json:"pageSize"`
}

type ResponseBody struct {
	Places []struct {
		Photos []struct {
			Name string `json:"name"`
		} `json:"photos"`
	} `json:"places"`
}

// function to get a place photo name from google maps api
func SearchPlaces(query string) (string, error) {
	url := "https://places.googleapis.com/v1/places:searchText"

	requestBody := RequestBody{
		TextQuery: query,
		PageSize:  1,
	}
	jsonData, err := json.Marshal(requestBody)
	if err != nil {
		return "", fmt.Errorf("error marshalling request body: %v", err)
	}

	// Create a new POST request
	req, err := http.NewRequest("POST", url, bytes.NewBuffer(jsonData))
	if err != nil {
		return "", fmt.Errorf("error creating request: %v", err)
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("X-Goog-Api-Key", viper.GetString("GOOGLE_API_KEY"))
	req.Header.Set("X-Goog-FieldMask", "places.formattedAddress,places.photos")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return "", fmt.Errorf("error sending request: %v", err)
	}
	defer resp.Body.Close()

	// On decode la réponse
	var result ResponseBody
	err = json.NewDecoder(resp.Body).Decode(&result)
	if err != nil {
		return "", fmt.Errorf("error decoding response: %v", err)
	}

	// Return the first photo name
	if len(result.Places) > 0 && len(result.Places[0].Photos) > 0 {
		return result.Places[0].Photos[0].Name, nil
	}

	return "", fmt.Errorf("no photo found")
}

// function that build the place photo uri from the photo name
func buildPhotoURI(photoName string) string {
	url := fmt.Sprintf("https://places.googleapis.com/v1/%s/media?key=%s&maxHeightPx=800&maxWidthPx=400",
		photoName, viper.GetString("GOOGLE_API_KEY"))
	return url
}

// Function to call the google maps api to get the photo uri
func getPhotoURI(photoName string) (string, error) {
	url := buildPhotoURI(photoName)

	client := &http.Client{}
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return "", fmt.Errorf("error creating request: %v", err)
	}

	resp, err := client.Do(req)
	if err != nil {
		return "", fmt.Errorf("error sending request: %v", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode >= 400 && resp.StatusCode < 500 {
		return "", fmt.Errorf("error getting photo URI (probably Google side): %v", resp.Status)
	}

	// Return the photo URI to make a request to get the photo file from google servers
	return url, nil
}

// function that get the photo uri from the place name and return the final photo file url
func GetPhotoURIFromPlaceName(placeName string) (string, error) {
	//L'api de gmap est nulle, obligé de rajouter "rue principale" ou "mairie" pour avoir des résultats
	photoName, err := SearchPlaces(placeName + " mairie")
	if err != nil {
		return "", fmt.Errorf("error searching places: %v", err)
	}

	photoURI, err := getPhotoURI(photoName)
	if err != nil {
		return "", fmt.Errorf("error getting photo URI: %v", err)
	}

	return photoURI, nil
}
