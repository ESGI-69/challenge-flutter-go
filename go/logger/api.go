package logger

import (
	"challenge-flutter-go/config"
	"challenge-flutter-go/models"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

func buildApiLogInfo(context *gin.Context, message string) additionalLogInfo {
	ip := context.ClientIP()
	path := context.Request.URL.EscapedPath()
	verb := context.Request.Method
	authorisationHeader := context.Request.Header.Get("Authorization")
	var username string
	if authorisationHeader != "" {
		token := strings.Split(context.Request.Header.Get("Authorization"), " ")[1]
		tokenPayload := jwt.MapClaims{}
		jwt.ParseWithClaims(token, tokenPayload, func(t *jwt.Token) (interface{}, error) {
			return []byte(config.GetConfig().JwtSecret), nil
		})
		username = tokenPayload["username"].(string)
	}
	var fullMessage string
	fullMessage = "IP: " + ip
	fullMessage += " | Path: " + path
	fullMessage += " | Method: " + verb
	if username != "" {
		fullMessage += " | Username: " + username
	}
	fullMessage += " | " + message
	return additionalLogInfo{
		Ip:              ip,
		Path:            path,
		Method:          verb,
		Username:        username,
		EnrichedMessage: fullMessage,
	}
}

func ApiInfo(context *gin.Context, message string) {
	additionalInfo := buildApiLogInfo(context, message)
	logger.writeLog(models.LogLevelInfo, message, &additionalInfo)
}

func ApiWarning(context *gin.Context, message string) {
	additionalInfo := buildApiLogInfo(context, message)
	logger.writeLog(models.LogLevelWarn, message, &additionalInfo)
}

func ApiError(context *gin.Context, message string) {
	additionalInfo := buildApiLogInfo(context, message)
	logger.writeLog(models.LogLevelError, message, &additionalInfo)
}
