package utils

import (
	"fmt"
	"io"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

// DownloadImageFromURL downloads an image from the provided URL and saves it to the server.
func DownloadImageFromURL(context *gin.Context, imageURL string) (string, error) {
	if imageURL == "" {
		return "", fmt.Errorf("image URL is empty")
	}

	// Download the image from the URL
	response, err := http.Get(imageURL)
	if err != nil {
		return "", fmt.Errorf("error downloading image from URL: %v", err)
	}
	defer response.Body.Close()

	if response.StatusCode != http.StatusOK {
		return "", fmt.Errorf("received non-OK HTTP status from image URL: %s", response.Status)
	}

	// Ensure the directory for storing images exists
	err = os.MkdirAll("banner", os.ModePerm)
	if err != nil {
		return "", fmt.Errorf("error creating directory for image: %v", err)
	}

	// Generate a unique filename for the image
	uniqueTitle, uuidErr := uuid.NewV7()
	if uuidErr != nil {
		return "", fmt.Errorf("error generating UUID for image: %v", uuidErr)
	}
	filePath := fmt.Sprintf("banner/%s.jpg", uniqueTitle)

	// Create the file on the server
	file, err := os.Create(filePath)
	if err != nil {
		return "", fmt.Errorf("error creating file for image: %v", err)
	}
	defer file.Close()

	// Copy the downloaded image to the file
	_, err = io.Copy(file, response.Body)
	if err != nil {
		return "", fmt.Errorf("error copying image to file: %v", err)
	}

	return uniqueTitle.String(), nil
}
