package api

import (
	_ "challenge-flutter-go/api/docs"
	"challenge-flutter-go/api/handlers"
	"challenge-flutter-go/api/middlewares"
	"challenge-flutter-go/config"
	"challenge-flutter-go/database"
	"challenge-flutter-go/repository"

	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
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

	userRepository := repository.UserRepository{
		Database: databaseInstance,
	}

	tripRepository := repository.TripRepository{
		Database: databaseInstance,
	}

	transportRepository := repository.TransportRepository{
		Database: databaseInstance,
	}

	userHandler := handlers.UserHandler{
		Repository: userRepository,
	}

	authHandler := handlers.AuthHandler{
		UserRepository: userRepository,
	}

	tripHandler := handlers.TripHandler{
		Repository: tripRepository,
	}

	transportHandler := handlers.TransportHandler{
		Repository:     transportRepository,
		TripRepository: tripRepository,
	}

	participantHandler := handlers.ParticipantHandler{
		TripRepository: tripRepository,
		UserRepository: userRepository,
	}

	router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	router.POST("/login", authHandler.Login)

	router.GET("/users/:id", middlewares.AuthorizationsMiddleware, userHandler.Get)
	router.POST("/users", userHandler.Create)

	router.POST("/trips", middlewares.AuthorizationsMiddleware, tripHandler.Create)
	router.GET("/trips", middlewares.AuthorizationsMiddleware, tripHandler.GetAllJoined)
	router.GET("/trips/:id", middlewares.AuthorizationsMiddleware, tripHandler.Get)
	router.POST("/trips/join", middlewares.AuthorizationsMiddleware, tripHandler.Join)
	router.POST("/trips/:id/leave", middlewares.AuthorizationsMiddleware, tripHandler.Leave)

	router.POST("/trips/:id/transport", middlewares.AuthorizationsMiddleware, transportHandler.AddTransportToTrip)
	router.DELETE("/trips/:id/transport/:transportID", middlewares.AuthorizationsMiddleware, transportHandler.DeleteTransportFromTrip)

	router.PATCH("/trips/:tripId/participants/:participantId/role", middlewares.AuthorizationsMiddleware, participantHandler.ChangeRole)
}

func Start() {
	router.Run()
}
