package api

import (
	"challenge-flutter-go/api/handler"
	"challenge-flutter-go/config"
	"challenge-flutter-go/database"
	"challenge-flutter-go/repository"

	"github.com/gin-gonic/gin"
)

var router *gin.Engine

func init() {
	gin.SetMode(config.GetConfig().Mode)
	router = gin.New()
	router.SetTrustedProxies([]string{"*"})
	setRoutes()
}

func setRoutes() {
	var userHandler = handler.UserHandler{
		Repository: repository.UserRepository{
			Database: database.GetInstance(),
		},
	}
	router.GET("/users/:id", userHandler.Get)
}

func Start() {
	router.Run()
}
