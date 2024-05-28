package handlers

import (
	"challenge-flutter-go/api/utils"
	"challenge-flutter-go/config"
	"challenge-flutter-go/repository"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

type AuthHandler struct {
	UserRepository repository.UserRepository
}

func (handler *AuthHandler) Login(context *gin.Context) {
	type RequestBody struct {
		Username string `json:"username" binding:"required"`
		Password string `json:"password" binding:"required"`
	}

	var requestBody RequestBody
	isBodyValid := utils.Deserialize(&requestBody, context)
	if !isBodyValid {
		return
	}

	user, databaseError := handler.UserRepository.FindByUsername(requestBody.Username)

	if !handler.UserRepository.ComparePassword(user, requestBody.Password) || databaseError != nil {
		context.AbortWithStatus(http.StatusUnauthorized)
		return
	}

	token, tokenCreationError := createJwt(user.Username)

	if tokenCreationError != nil {
		context.JSON(http.StatusInternalServerError, gin.H{"tokenCreationError": tokenCreationError})
		return
	}

	context.JSON(http.StatusOK, gin.H{
		"token": token,
	})
}

func createJwt(username string) (string, error) {
	token := jwt.NewWithClaims(
		jwt.SigningMethodHS256,
		jwt.MapClaims{
			"username": username,
			"exp":      time.Now().Add(time.Hour * 72).Unix(),
		},
	)

	return token.SignedString([]byte(config.GetConfig().JwtSecret))
}
