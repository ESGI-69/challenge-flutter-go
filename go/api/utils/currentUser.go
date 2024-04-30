package utils

import (
	"challenge-flutter-go/models"

	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
)

func GetCurrentUser(context *gin.Context) models.User {
	currentUserInterface, exist := context.Get("currentUser")
	if !exist {
		context.AbortWithStatus(401)
		return models.User{}
	}

	validator := validator.New()
	validator.Struct(currentUserInterface)

	return currentUserInterface.(models.User)
}
