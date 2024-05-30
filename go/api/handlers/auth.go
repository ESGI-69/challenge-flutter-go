package handlers

import (
	"challenge-flutter-go/api/requests"
	"challenge-flutter-go/api/responses"
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

// Login the user
//
//	@Summary		Login the user
//	@Description	Login the user
//	@Tags			auth
//	@Accept			json
//	@Produce		json
//	@Param			body	body		requests.AuthLoginBody	true	"Body of the request"
//	@Success		200		{object}	responses.LoginResponse
//	@Failure		400		{object}	error
//	@Failure		401		{object}	error
//	@Router			/login [post]
func (handler *AuthHandler) Login(context *gin.Context) {

	var requestBody requests.AuthLoginBody
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

	context.JSON(http.StatusOK, responses.LoginResponse{Token: token})
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
