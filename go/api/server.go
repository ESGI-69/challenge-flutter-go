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

	AccommodationRepository := repository.AccommodationRepository{
		Database: databaseInstance,
	}

	noteRepository := repository.NoteRepository{
		Database: databaseInstance,
	}

	chatMessageRepository := repository.ChatMessageRepository{
		Database: databaseInstance,
	}

	documentRepository := repository.DocumentRepository{
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

	accommodationHandler := handlers.AccommodationHandler{
		Repository:     AccommodationRepository,
		TripRepository: tripRepository,
	}

	documentHandler := handlers.DocumentHandler{
		Repository:     documentRepository,
		TripRepository: tripRepository,
	}

	router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	router.POST("/login", authHandler.Login)

	usersRoutes := router.Group("/users")
	usersRoutes.POST("/", userHandler.Create)
	usersRoutes.GET("/:id", middlewares.UserIsLogged, userHandler.Get)

	tripsRoutes := router.Group("/trips", middlewares.UserIsLogged)
	tripsRoutes.POST("/", tripHandler.Create)
	tripsRoutes.GET("/", tripHandler.GetAllJoined)
	tripsRoutes.GET("/:id", middlewares.UserIsTripParticipant, tripHandler.Get)
	tripsRoutes.PATCH("/:id", middlewares.UserHasTripEditRight, tripHandler.Update)
	tripsRoutes.POST("/join", tripHandler.Join)
	tripsRoutes.POST("/:id/leave", middlewares.UserIsTripParticipant, tripHandler.Leave)

	tripTransportsRoutes := tripsRoutes.Group("/:id/transports")
	tripTransportsRoutes.GET("/", middlewares.UserIsTripParticipant, transportHandler.GetAllFromTrip)
	tripTransportsRoutes.POST("/", middlewares.UserHasTripEditRight, transportHandler.Create)
	tripTransportsRoutes.DELETE("/:transportID", middlewares.UserHasTripEditRight, transportHandler.DeleteTransport)

	tripParticipantsRoutes := tripsRoutes.Group("/:id/participants", middlewares.UserIsTripOwner)
	tripParticipantsRoutes.PATCH("/:participantId/role", participantHandler.ChangeRole)
	tripParticipantsRoutes.DELETE("/:participantId/", participantHandler.RemoveParticipant)

	tripAccommodationsRoutes := tripsRoutes.Group("/:id/accommodations")
	tripAccommodationsRoutes.GET("/", middlewares.UserIsTripParticipant, accommodationHandler.GetAllFromTrip)
	tripAccommodationsRoutes.POST("/", middlewares.UserHasTripEditRight, accommodationHandler.Create)
	tripAccommodationsRoutes.DELETE("/:accommodationID", middlewares.UserHasTripEditRight, accommodationHandler.DeleteAccommodation)

	tripNotesRoutes := tripsRoutes.Group("/:id/notes")
	tripNotesRoutes.GET("/", middlewares.UserIsTripParticipant, noteHandler.GetNotesOfTrip)
	tripNotesRoutes.POST("/", middlewares.UserHasTripEditRight, noteHandler.AddNoteToTrip)
	tripNotesRoutes.DELETE("/:noteID", middlewares.UserHasTripEditRight, noteHandler.DeleteNoteFromTrip)

	tripChatMessagesRoutes := tripsRoutes.Group("/:id/chatMessages")
	tripChatMessagesRoutes.GET("/", middlewares.UserIsTripParticipant, chatMessageHandler.GetChatMessagesOfTrip)
	tripChatMessagesRoutes.POST("/", middlewares.UserHasTripEditRight, chatMessageHandler.AddChatMessageToTrip)

	// Document's trip routes
	// post and check if user has edit right and the route should accept a file (multipart/form-data)
	tripDocumentsRoutes := tripsRoutes.Group("/:id/documents")
	tripDocumentsRoutes.GET("/", middlewares.UserIsTripParticipant, documentHandler.GetDocumentsOfTrip)
	tripDocumentsRoutes.POST("/", middlewares.UserHasTripEditRight, documentHandler.CreateDocument)

	router.GET("/health", func(c *gin.Context) {
		c.Status(http.StatusOK)
	})
}

func Start() {
	router.Run()
}
