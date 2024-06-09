package middlewares

import (
	"challenge-flutter-go/api/errorHandlers"
	"challenge-flutter-go/api/utils"
	"challenge-flutter-go/database"
	"challenge-flutter-go/models"
	"strconv"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

var databaseInstance *gorm.DB

func init() {
	databaseInstance = database.GetInstance()
}

func UserIsTripOwner(context *gin.Context) {
	var trip models.Trip
	var loggedUser models.User
	retriveTripAndUser(context, &trip, &loggedUser)

	if !trip.UserIsOwner(&loggedUser) {
		context.AbortWithStatusJSON(401, gin.H{"error": "You need to be the owner of the trip to perform this action"})
		return
	}

	context.Next()
}

func UserHasTripEditRight(context *gin.Context) {
	var trip models.Trip
	var user models.User
	retriveTripAndUser(context, &trip, &user)

	if !trip.UserHasEditRight(&user) {
		context.AbortWithStatusJSON(401, gin.H{"error": "You need to have the right to edit the trip to perform this action"})
		return
	}

	context.Next()
}

func UserIsTripParticipant(context *gin.Context) {
	var trip models.Trip
	var user models.User
	retriveTripAndUser(context, &trip, &user)

	if !trip.UserHasViewRight(&user) {
		context.AbortWithStatusJSON(401, gin.H{"error": "You need to be a participant of the trip to perform this action"})
		return
	}

	context.Next()
}

func retriveTripAndUser(context *gin.Context, trip *models.Trip, user *models.User) {
	currentUser, exist := utils.GetCurrentUser(context)
	if !exist {
		context.AbortWithStatusJSON(401, gin.H{"error": "Unauthorized"})
		return
	}

	tripId := context.Param("id")
	if tripId == "" {
		context.AbortWithStatusJSON(400, gin.H{"error": "Invalid trip ID"})
		return
	}

	tripIdUint, err := strconv.ParseUint(tripId, 10, 64)
	if err != nil {
		context.AbortWithStatusJSON(400, gin.H{"error": "Invalid trip ID"})
		return
	}

	*trip = models.Trip{Model: gorm.Model{ID: uint(tripIdUint)}}

	databaseErr := databaseInstance.Model(&trip).Preload(clause.Associations).First(&trip).Error
	if databaseErr != nil {
		errorHandlers.HandleGormErrors(databaseErr, context)
		return
	}

	*user = currentUser
}
