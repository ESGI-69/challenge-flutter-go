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
	tripsRoutes.GET("/:id", middlewares.UserHasViewRight, tripHandler.Get)
	tripsRoutes.PATCH("/:id", middlewares.UserHasEditRight, tripHandler.Update)
	tripsRoutes.POST("/join", tripHandler.Join)
	tripsRoutes.POST("/:id/leave", middlewares.UserHasViewRight, tripHandler.Leave)

	tripTransportsRoutes := tripsRoutes.Group("/:id/transports")
	tripTransportsRoutes.GET("/", middlewares.UserHasViewRight, transportHandler.GetAllFromTrip)
	tripTransportsRoutes.POST("/", middlewares.UserHasEditRight, transportHandler.CreateOnTrip)
	tripTransportsRoutes.DELETE("/:transportID", middlewares.UserHasEditRight, transportHandler.DeleteTransport)

	tripParticipantsRoutes := tripsRoutes.Group("/:id/participants", middlewares.UserIsOwner)
	tripParticipantsRoutes.PATCH("/:participantId/role", participantHandler.ChangeRole)
	tripParticipantsRoutes.DELETE("/:participantId/", participantHandler.RemoveParticipant)

	tripNotesRoutes := tripsRoutes.Group("/:id/notes")
	tripNotesRoutes.GET("/", middlewares.UserHasViewRight, noteHandler.GetNotesOfTrip)
	tripNotesRoutes.POST("/", middlewares.UserHasEditRight, noteHandler.AddNoteToTrip)
	tripNotesRoutes.DELETE("/:noteID", middlewares.UserHasEditRight, noteHandler.DeleteNoteFromTrip)

	tripChatMessagesRoutes := tripsRoutes.Group("/:id/chatMessages")
	tripChatMessagesRoutes.GET("/", middlewares.UserHasViewRight, chatMessageHandler.GetChatMessagesOfTrip)
	tripChatMessagesRoutes.POST("/", middlewares.UserHasEditRight, chatMessageHandler.AddChatMessageToTrip)

	router.GET("/health", func(c *gin.Context) {
		c.Status(http.StatusOK)
	})
}

func Start() {
	router.Run()
}
