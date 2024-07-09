package middlewares

import (
	"challenge-flutter-go/api/errorHandlers"
	"challenge-flutter-go/api/utils"
	"challenge-flutter-go/database"
	"challenge-flutter-go/logger"
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

// Check if the trip ID is correct, if the trip exist, and if the logged user is the owner of the trip
func UserIsTripOwner(context *gin.Context) {
	tripId := context.Param("id")

	var trip models.Trip
	var user models.User
	err := retriveTripAndUser(context, &trip, &user, tripId)
	if err {
		return
	}

	if !trip.UserIsOwner(&user) {
		logger.ApiWarning(context, "Access denied, owner of the trip is different from the logged user")
		context.AbortWithStatusJSON(401, gin.H{"error": "You need to be the owner of the trip to perform this action"})
		return
	}

	context.Next()
}

// Check if the trip ID is correct, if the trip exist, and if the logged user is the owner of the trip
func UserHasTripEditRight(context *gin.Context) {
	tripId := context.Param("id")

	var trip models.Trip
	var user models.User
	err := retriveTripAndUser(context, &trip, &user, tripId)
	if err {
		return
	}

	if !trip.UserHasEditRight(&user) {
		logger.ApiWarning(context, "Access denied, user does not have the right to edit the trip")
		context.AbortWithStatusJSON(401, gin.H{"error": "You need to have the right to edit the trip to perform this action"})
		return
	}

	context.Next()
}

func UserIsTripParticipant(context *gin.Context) {
	tripId := context.Param("id")

	var trip models.Trip
	var user models.User
	err := retriveTripAndUser(context, &trip, &user, tripId)
	if err {
		return
	}

	if !trip.UserHasViewRight(&user) {
		logger.ApiWarning(context, "Access denied, user is not a participant of the trip")
		context.AbortWithStatusJSON(401, gin.H{"error": "You need to be a participant of the trip to perform this action"})
		return
	}
	context.Next()
}

func retriveTripAndUser(context *gin.Context, trip *models.Trip, user *models.User, tripId string) bool {
	currentUser, exist := utils.GetCurrentUser(context)
	if !exist {
		logger.ApiError(context, "User not found")
		context.AbortWithStatusJSON(401, gin.H{"error": "Unauthorized"})
		return true
	}

	if tripId == "" {
		logger.ApiError(context, "Trip ID missing in the request")
		context.AbortWithStatusJSON(400, gin.H{"error": "Invalid trip ID"})
		return true
	}

	tripIdUint, err := strconv.ParseUint(tripId, 10, 64)
	if err != nil {
		logger.ApiError(context, "Trip ID must be a number")
		context.AbortWithStatusJSON(400, gin.H{"error": "Invalid trip ID"})
		return true
	}

	*trip = models.Trip{Model: gorm.Model{ID: uint(tripIdUint)}}

	databaseErr := databaseInstance.Model(&trip).Preload(clause.Associations).First(&trip).Error
	if databaseErr != nil {
		errorHandlers.HandleGormErrors(databaseErr, context)
		return true
	}

	*user = currentUser
	return false
}
