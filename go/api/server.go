package api

import (
	"challenge-flutter-go/api/handlers"
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
	databaseInstance := database.GetInstance()

	var userHandler = handlers.UserHandler{
		Repository: repository.UserRepository{
			Database: databaseInstance,
		},
	}

	var authHandler = handlers.AuthHandler{
		UserRepository: repository.UserRepository{
			Database: databaseInstance,
		},
	}

	router.GET("/users/:id", userHandler.Get)
	router.POST("/users", userHandler.Create)
	router.POST("/login", authHandler.Login)
}

func Start() {
	router.Run()
}
