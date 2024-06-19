package utils

import (
	"challenge-flutter-go/api/errorHandlers"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
)

// Write the body of the request to the object passed as parameter
// If the body is missing fields or has invalid fields, the function will return false and call the errorHandlers
// Otherwise, it will return true
func Deserialize(object any, context *gin.Context) (passed bool) {
	requiredError := context.ShouldBindJSON(&object)
	// requiredError EOF equivalent to missing body
	if context.Request.Body == http.NoBody {
		errorHandlers.HandleMissingBodyError(context)
		return false
	}
	if requiredError != nil {
		errorHandlers.HandleBodyMissingFieldsError(requiredError, context)
		return false
	}
	validate := validator.New()
	_ = validate.RegisterValidation("not_trimmed_empty", notTrimmedEmpty)
	validatorError := validate.Struct(object)
	if validatorError != nil {
		errorHandlers.HandleBodyInvalidFieldsError(validatorError, context)
		return false
	}
	return true
}

func notTrimmedEmpty(fl validator.FieldLevel) bool {
	return strings.ReplaceAll(fl.Field().String(), " ", "") != ""
}
