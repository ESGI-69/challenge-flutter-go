package api

import (
	_ "challenge-flutter-go/api/docs"
	"challenge-flutter-go/api/handlers"
	"challenge-flutter-go/api/middlewares"
	"challenge-flutter-go/config"
	"challenge-flutter-go/database"
	"challenge-flutter-go/repository"
	"net/http"

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

	noteRepository := repository.NoteRepository{
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

	noteHandler := handlers.NoteHandler{
		Repository:     noteRepository,
		TripRepository: tripRepository,
	}

	router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	router.POST("/login", authHandler.Login)

	router.GET("/users/:id", middlewares.AuthorizationsMiddleware, userHandler.Get)
	router.POST("/users", userHandler.Create)

	router.POST("/trips", middlewares.AuthorizationsMiddleware, tripHandler.Create)
	router.GET("/trips", middlewares.AuthorizationsMiddleware, tripHandler.GetAllJoined)
	router.GET("/trips/:id", middlewares.AuthorizationsMiddleware, tripHandler.Get)
	router.PATCH("/trips/:id", middlewares.AuthorizationsMiddleware, tripHandler.Update)
	router.POST("/trips/join", middlewares.AuthorizationsMiddleware, tripHandler.Join)
	router.POST("/trips/:id/leave", middlewares.AuthorizationsMiddleware, tripHandler.Leave)

	router.GET("/trips/:id/transports", middlewares.AuthorizationsMiddleware, transportHandler.GetAllFromTrip)
	router.POST("/trips/:id/transports", middlewares.AuthorizationsMiddleware, transportHandler.CreateOnTrip)
	// router.DELETE("/trips/:id/transports/:transportID", middlewares.AuthorizationsMiddleware, transportHandler.DeleteTransportFromTrip)

	router.PATCH("/trips/:id/participants/:participantId/role", middlewares.AuthorizationsMiddleware, participantHandler.ChangeRole)
	router.DELETE("/trips/:id/participants/:participantId/", middlewares.AuthorizationsMiddleware, participantHandler.RemoveParticipant)

	router.GET("/trips/:id/notes", middlewares.AuthorizationsMiddleware, noteHandler.GetNotesOfTrip)
	router.POST("/trips/:id/notes", middlewares.AuthorizationsMiddleware, noteHandler.AddNoteToTrip)
	router.DELETE("/trips/:id/notes/:noteID", middlewares.AuthorizationsMiddleware, noteHandler.DeleteNoteFromTrip)

	router.GET("/health", func(c *gin.Context) {
		c.Status(http.StatusOK)
	})
}

func Start() {
	router.Run()
}
