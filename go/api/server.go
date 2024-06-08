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

	chatMessageRepository := repository.ChatMessageRepository{
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

	chatMessageHandler := handlers.ChatMessageHandler{
		Repository:     chatMessageRepository,
		TripRepository: tripRepository,
	}

	router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	router.POST("/login", authHandler.Login)

	usersRoutes := router.Group("/users")
	usersRoutes.POST("/", userHandler.Create)
	usersRoutes.GET("/:id", middlewares.AuthorizationsMiddleware, userHandler.Get)

	tripsRoutes := router.Group("/trips", middlewares.AuthorizationsMiddleware)
	tripsRoutes.POST("/", tripHandler.Create)
	tripsRoutes.GET("/", tripHandler.GetAllJoined)
	tripsRoutes.GET("/:id", middlewares.UserHasTripViewRight, tripHandler.Get)
	tripsRoutes.PATCH("/:id", middlewares.UserHasTripEditRight, tripHandler.Update)
	tripsRoutes.POST("/join", tripHandler.Join)
	tripsRoutes.POST("/:id/leave", middlewares.UserHasTripViewRight, tripHandler.Leave)

	tripTransportsRoutes := tripsRoutes.Group("/:id/transports")
	tripTransportsRoutes.GET("/", middlewares.UserHasTripViewRight, transportHandler.GetAllFromTrip)
	tripTransportsRoutes.POST("/", middlewares.UserHasTripEditRight, transportHandler.CreateOnTrip)
	tripTransportsRoutes.DELETE("/:transportID", middlewares.UserHasTripEditRight, transportHandler.DeleteTransport)

	tripParticipantsRoutes := tripsRoutes.Group("/:id/participants", middlewares.UserIsTripOwner)
	tripParticipantsRoutes.PATCH("/:participantId/role", participantHandler.ChangeRole)
	tripParticipantsRoutes.DELETE("/:participantId/", participantHandler.RemoveParticipant)

	tripNotesRoutes := tripsRoutes.Group("/:id/notes")
	tripNotesRoutes.GET("/", middlewares.UserHasTripViewRight, noteHandler.GetNotesOfTrip)
	tripNotesRoutes.POST("/", middlewares.UserHasTripEditRight, noteHandler.AddNoteToTrip)
	tripNotesRoutes.DELETE("/:noteID", middlewares.UserHasTripEditRight, noteHandler.DeleteNoteFromTrip)

	tripChatMessagesRoutes := tripsRoutes.Group("/:id/chatMessages")
	tripChatMessagesRoutes.GET("/", middlewares.UserHasTripViewRight, chatMessageHandler.GetChatMessagesOfTrip)
	tripChatMessagesRoutes.POST("/", middlewares.UserHasTripEditRight, chatMessageHandler.AddChatMessageToTrip)

	router.GET("/health", func(c *gin.Context) {
		c.Status(http.StatusOK)
	})
}

func Start() {
	router.Run()
}
