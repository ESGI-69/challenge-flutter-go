package middlewares

import (
	"challenge-flutter-go/config"
	"fmt"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

func AuthorizationsMiddleware(context *gin.Context) {
	authorizationHeader := context.Request.Header.Get("Authorization")

	token := strings.TrimPrefix(authorizationHeader, "Bearer ")

	if err := isTokenValid(token); err != nil {
		context.AbortWithStatus(http.StatusUnauthorized)
		return
	}
}

func isTokenValid(token string) error {
	_, err := jwt.Parse(token, func(t *jwt.Token) (interface{}, error) {
		if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", t.Header["alg"])
		}

		return []byte(config.GetConfig().JwtSecret), nil
	})

	return err
}
