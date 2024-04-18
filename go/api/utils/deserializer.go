package utils

import (
	"challenge-flutter-go/api/errorHandlers"

	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
)

// Write the body of the request to the object passed as parameter
// If the body is missing fields or has invalid fields, the function will return false and call the errorHandlers
// Otherwise, it will return true
func Deserialize(object any, context *gin.Context) (passed bool) {
	requiredError := context.ShouldBindJSON(&object)
	if requiredError != nil {
		errorHandlers.HandleBodyMissingFieldsError(requiredError, context)
		return false
	}
	validate := validator.New()
	validatorError := validate.Struct(object)
	if validatorError != nil {
		errorHandlers.HandleBodyInvalidFieldsError(validatorError, context)
		return false
	}
	return true
}
