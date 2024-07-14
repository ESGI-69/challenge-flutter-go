package api

import (
	_ "challenge-flutter-go/api/docs"
	"challenge-flutter-go/api/handlers"
	"challenge-flutter-go/api/middlewares"
	"challenge-flutter-go/config"
	"challenge-flutter-go/database"
	"challenge-flutter-go/logger"
	"challenge-flutter-go/repository"
	"net/http"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"

	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

var router *gin.Engine

func init() {
	gin.SetMode(config.GetConfig().Mode)
	router = gin.New()
	router.SetTrustedProxies([]string{"*"})
	router.Use(cors.New(cors.Config{
		AllowOrigins:     []string{config.GetConfig().FrontendURL},
		AllowMethods:     []string{"GET", "POST", "PATCH", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
		AllowCredentials: true,
	}))
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

	accommodationRepository := repository.AccommodationRepository{
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

	photoRepository := repository.PhotoRepository{
		Database: databaseInstance,
	}

	featureRepository := repository.FeatureRepository{
		Database: databaseInstance,
	}

	activityRepository := repository.ActivityRepository{
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
		Repository:     accommodationRepository,
		TripRepository: tripRepository,
	}

	documentHandler := handlers.DocumentHandler{
		Repository:     documentRepository,
		TripRepository: tripRepository,
	}

	socketHandler := handlers.SocketHandler{}

	photoHandler := handlers.PhotoHandler{
		Repository:     photoRepository,
		TripRepository: tripRepository,
	}

	featureHandler := handlers.FeatureHandler{
		Repository: featureRepository,
	}

	activityHandler := handlers.ActivityHandler{
		Repository:     activityRepository,
		TripRepository: tripRepository,
	}

	router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	router.Static("/backoffice", "./backoffice")

	router.POST("/login", authHandler.Login)

	adminsRoutes := router.Group("/admin", middlewares.UserIsLogged, middlewares.UserIsAdmin)

	adminsTripRoutes := adminsRoutes.Group("/trips")
	adminsTripRoutes.GET("", tripHandler.GetAll)
	adminsTripRoutes.GET("/:id", tripHandler.Get)
	adminsTripRoutes.DELETE("/:id", tripHandler.Delete)

	adminsFeatureRoutes := adminsRoutes.Group("/app-settings")
	adminsFeatureRoutes.GET("", featureHandler.GetFeaturesAdmin)
	adminsFeatureRoutes.PATCH("/:name", featureHandler.Update)

	adminsUsersRoutes := adminsRoutes.Group("/users")
	adminsUsersRoutes.GET("", userHandler.GetAll)
	adminsUsersRoutes.PATCH("/:id/role", userHandler.UpdateRole)

	usersRoutes := router.Group("/users")
	usersRoutes.POST("", userHandler.Create)
	usersRoutes.GET("/:id", middlewares.UserIsLogged, userHandler.Get)
	usersRoutes.PATCH("/photo", middlewares.UserIsLogged, userHandler.UpdatePhoto)
	usersRoutes.PATCH("/:id", middlewares.UserIsLogged, userHandler.Update)
	usersRoutes.GET("/photo/:userId", userHandler.DownloadPhoto)

	tripsRoutes := router.Group("/trips", middlewares.UserIsLogged)
	tripsRoutes.POST("", tripHandler.Create)
	tripsRoutes.GET("", tripHandler.GetAllJoined)
	tripsRoutes.GET("/:id", middlewares.UserIsTripParticipant, tripHandler.Get)
	tripsRoutes.PATCH("/:id", middlewares.UserHasTripEditRight, tripHandler.Update)
	tripsRoutes.POST("/join", tripHandler.Join)
	tripsRoutes.POST("/:id/leave", middlewares.UserIsTripParticipant, tripHandler.Leave)
	tripsRoutes.DELETE("/:id", middlewares.UserIsTripOwner, tripHandler.Delete)
	tripsRoutes.GET("/:id/banner/download", middlewares.UserIsTripParticipant, tripHandler.DownloadTripBanner)

	tripTransportsRoutes := tripsRoutes.Group("/:id/transports")
	tripTransportsRoutes.GET("", middlewares.UserIsTripParticipant, transportHandler.GetAllFromTrip)
	tripTransportsRoutes.POST("", middlewares.UserHasTripEditRight, transportHandler.Create)
	tripTransportsRoutes.DELETE("/:transportID", middlewares.UserHasTripEditRight, middlewares.TransportBelongsToTrip, transportHandler.DeleteTransport)

	tripParticipantsRoutes := tripsRoutes.Group("/:id/participants", middlewares.UserIsTripParticipant)
	tripParticipantsRoutes.GET("", participantHandler.GetAllFromTrip)
	tripParticipantsRoutes.PATCH("/:participantId/role", middlewares.UserIsTripOwner, middlewares.ParticipantBelongsToTrip, participantHandler.ChangeRole)
	tripParticipantsRoutes.DELETE("/:participantId", middlewares.UserIsTripOwner, middlewares.ParticipantBelongsToTrip, participantHandler.RemoveParticipant)

	tripAccommodationsRoutes := tripsRoutes.Group("/:id/accommodations")
	tripAccommodationsRoutes.GET("", middlewares.UserIsTripParticipant, accommodationHandler.GetAllFromTrip)
	tripAccommodationsRoutes.POST("", middlewares.UserHasTripEditRight, accommodationHandler.Create)
	tripAccommodationsRoutes.DELETE("/:accommodationID", middlewares.UserHasTripEditRight, middlewares.AccommodationBelongsToTrip, accommodationHandler.DeleteAccommodation)

	tripNotesRoutes := tripsRoutes.Group("/:id/notes")
	tripNotesRoutes.GET("", middlewares.UserIsTripParticipant, noteHandler.GetNotesOfTrip)
	tripNotesRoutes.POST("", middlewares.UserHasTripEditRight, noteHandler.AddNoteToTrip)
	tripNotesRoutes.DELETE("/:noteID", middlewares.UserHasTripEditRight, middlewares.NoteBelongsToTrip, noteHandler.DeleteNoteFromTrip)

	tripChatMessagesRoutes := tripsRoutes.Group("/:id/chatMessages", middlewares.UserIsTripParticipant)
	tripChatMessagesRoutes.GET("", chatMessageHandler.GetChatMessagesOfTrip)
	tripChatMessagesRoutes.POST("", chatMessageHandler.AddChatMessageToTrip)

	tripDocumentsRoutes := tripsRoutes.Group("/:id/documents")
	tripDocumentsRoutes.GET("", middlewares.UserIsTripParticipant, documentHandler.GetDocumentsOfTrip)
	tripDocumentsRoutes.POST("", middlewares.UserHasTripEditRight, documentHandler.CreateDocument)
	tripDocumentsRoutes.DELETE("/:documentID", middlewares.UserHasTripEditRight, middlewares.DocumentBelongsToTrip, documentHandler.DeleteDocumentFromTrip)
	tripDocumentsRoutes.GET("/:documentID/download", middlewares.UserIsTripParticipant, middlewares.DocumentBelongsToTrip, documentHandler.DownloadDocument)

	tripPhotosRoutes := tripsRoutes.Group("/:id/photos")
	tripPhotosRoutes.GET("", middlewares.UserIsTripParticipant, photoHandler.GetPhotosOfTrip)
	tripPhotosRoutes.POST("", middlewares.UserHasTripEditRight, photoHandler.CreatePhoto)
	tripPhotosRoutes.DELETE("/:photoID", middlewares.UserHasTripEditRight, middlewares.PhotoBelongsToTrip, photoHandler.DeletePhotoFromTrip)
	tripPhotosRoutes.GET("/:photoID/download", middlewares.UserIsTripParticipant, middlewares.PhotoBelongsToTrip, photoHandler.DownloadPhoto)

	tripActivitiesRoutes := tripsRoutes.Group("/:id/activities")
	tripActivitiesRoutes.GET("", middlewares.UserIsTripParticipant, activityHandler.GetAllFromTrip)
	tripActivitiesRoutes.POST("", middlewares.UserHasTripEditRight, activityHandler.Create)
	tripActivitiesRoutes.PATCH("/:activityID", middlewares.UserHasTripEditRight, middlewares.ActivityBelongsToTrip, activityHandler.Update)
	tripActivitiesRoutes.DELETE("/:activityID", middlewares.UserHasTripEditRight, middlewares.ActivityBelongsToTrip, activityHandler.Delete)

	featuresRoutes := router.Group("/app-settings")
	featuresRoutes.GET("", featureHandler.GetFeatures)

	socketRoutes := router.Group("/ws", middlewares.UserIsLoggedByParam)
	socketRoutes.GET("/chat", middlewares.SocketUserIsTripParticipant, socketHandler.HandleChatConnections)

	router.GET("/health", func(c *gin.Context) {
		c.Status(http.StatusOK)
	})
}

func Start() {
	logger.Info("API server started")
	socketHandler := &handlers.SocketHandler{}
	go socketHandler.HandleMessages()
	router.Run()
}
