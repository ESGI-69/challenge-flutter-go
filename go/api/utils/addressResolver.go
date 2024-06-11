package utils

import (
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"strconv"
)

// Return the geo location of a given address (latitude, longitude)
func GetGeoLocation(address string) (latitude float64, longitude float64, err error) {

	const openStreetMapUrl = "https://nominatim.openstreetmap.org/search?q=%s&format=json"
	url := fmt.Sprintf(openStreetMapUrl, url.QueryEscape(address))

	response, err := http.Get(url)
	if err != nil {
		return 0, 0, err
	}

	// Parse the response
	var locations []struct {
		Lat string `json:"lat"`
		Lon string `json:"lon"`
	}

	err = json.NewDecoder(response.Body).Decode(&locations)
	if err != nil {
		print("error : ", err)
		return 0, 0, err
	}

	if len(locations) > 0 {
		latitude, _ = strconv.ParseFloat(locations[0].Lat, 64)
		longitude, _ = strconv.ParseFloat(locations[0].Lon, 64)
		return latitude, longitude, nil
	}

	return 0, 0, nil
}
