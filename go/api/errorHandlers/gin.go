package errorHandlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
)

// Handles the error when the body of the request is missing fields
// It returns a JSON response with array of missing fields
func HandleBodyMissingFieldsError(err error, context *gin.Context) {
	var missingFields []string
	for _, err := range err.(validator.ValidationErrors) {
		missingFields = append(missingFields, err.Field())
	}
	context.JSON(http.StatusBadRequest, gin.H{"error": "Missing", "fields": missingFields})
}

// Handles the error when the body of the request has invalid fields
// It returns a JSON response with array of invalid fields
func HandleBodyInvalidFieldsError(err error, context *gin.Context) {
	var invalidFields []string
	for _, err := range err.(validator.ValidationErrors) {
		invalidFields = append(invalidFields, err.Field())
	}
	context.JSON(http.StatusBadRequest, gin.H{"error": "Invalid", "fields": invalidFields})
}
