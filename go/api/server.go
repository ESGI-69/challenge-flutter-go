package api

import (
	"esgi69/challenge-flutter-go/api/handler"
	"esgi69/challenge-flutter-go/config"
	"esgi69/challenge-flutter-go/database"
	"esgi69/challenge-flutter-go/repository"

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
