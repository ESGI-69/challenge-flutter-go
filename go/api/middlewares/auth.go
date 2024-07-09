package middlewares

import (
	"challenge-flutter-go/config"
	"challenge-flutter-go/database"
	"challenge-flutter-go/logger"
	"challenge-flutter-go/repository"
	"fmt"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

func UserIsLogged(context *gin.Context) {
	authorizationHeader := context.Request.Header.Get("Authorization")
	token := strings.TrimPrefix(authorizationHeader, "Bearer ")

	validateAndPopulateUser(token, context)
}

func UserIsLoggedByParam(context *gin.Context) {
	token := context.Query("token")

	validateAndPopulateUser(token, context)
}

func validateAndPopulateUser(token string, context *gin.Context) {
	if err := isTokenInvalid(token); err != nil {
		logger.ApiWarning(context, "Invalid token")
		context.AbortWithStatus(http.StatusUnauthorized)
		return
	}

	// decode
	payload := jwt.MapClaims{}
	_, err := jwt.ParseWithClaims(token, payload, func(t *jwt.Token) (interface{}, error) {
		return []byte(config.GetConfig().JwtSecret), nil
	})

	if err != nil {
		logger.ApiError(context, "Error while parsing token")
		context.AbortWithStatus(http.StatusUnauthorized)
		return
	}

	username := payload["username"].(string)

	if err := populateCurrentUser(username, context); err != nil {
		logger.ApiError(context, "Error while populating current user")
		context.AbortWithStatus(http.StatusUnauthorized)
		return
	}

	context.Next()
}

func isTokenInvalid(token string) error {
	_, err := jwt.Parse(token, func(t *jwt.Token) (interface{}, error) {
		if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", t.Header["alg"])
		}

		return []byte(config.GetConfig().JwtSecret), nil
	})

	return err
}

func populateCurrentUser(username string, context *gin.Context) (err error) {
	userRepository := repository.UserRepository{
		Database: database.GetInstance(),
	}

	user, err := userRepository.FindByUsername(username)

	context.Set("currentUser", user)

	return
}
