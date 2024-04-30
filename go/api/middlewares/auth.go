package middlewares

import (
	"challenge-flutter-go/config"
	"challenge-flutter-go/database"
	"challenge-flutter-go/repository"
	"fmt"
	"log"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

func AuthorizationsMiddleware(context *gin.Context) {
	authorizationHeader := context.Request.Header.Get("Authorization")

	token := strings.TrimPrefix(authorizationHeader, "Bearer ")

	if err := isTokenInvalid(token); err != nil {
		context.AbortWithStatus(http.StatusUnauthorized)
		return
	}

	// decode
	payload := jwt.MapClaims{}
	_, err := jwt.ParseWithClaims(token, payload, func(t *jwt.Token) (interface{}, error) {
		return []byte(config.GetConfig().JwtSecret), nil
	})

	if err != nil {
		context.AbortWithStatus(http.StatusUnauthorized)
		log.Printf("Error while parsing token. AuthorizationsMiddleware")
		return
	}

	username := payload["username"].(string)

	if err := populateCurrentUser(username, context); err != nil {
		context.AbortWithStatus(http.StatusUnauthorized)
		log.Printf("Error while populating current user. populateCurrentUser")
		return
	}

	context.Next()
}

func isTokenInvalid(token string) error {
	_, err := jwt.Parse(token, func(t *jwt.Token) (interface{}, error) {
		if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
			log.Printf("Error while validating token. isTokenInvalid")
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
