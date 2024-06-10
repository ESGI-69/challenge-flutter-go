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

// Check if the trip ID is correct, if the trip exist, and if the logged user is the owner of the trip
func UserIsTripOwner(context *gin.Context) {
	var trip models.Trip
	var user models.User
	err := retriveTripAndUser(context, &trip, &user)
	if err {
		return
	}

	if !trip.UserIsOwner(&user) {
		context.AbortWithStatusJSON(401, gin.H{"error": "You need to be the owner of the trip to perform this action"})
		return
	}

	context.Next()
}

// Check if the trip ID is correct, if the trip exist, and if the logged user is the owner of the trip
func UserHasTripEditRight(context *gin.Context) {
	var trip models.Trip
	var user models.User
	err := retriveTripAndUser(context, &trip, &user)
	if err {
		return
	}

	if !trip.UserHasEditRight(&user) {
		context.AbortWithStatusJSON(401, gin.H{"error": "You need to have the right to edit the trip to perform this action"})
		return
	}

	context.Next()
}

func UserIsTripParticipant(context *gin.Context) {
	var trip models.Trip
	var user models.User
	err := retriveTripAndUser(context, &trip, &user)
	if err {
		return
	}

	if !trip.UserHasViewRight(&user) {
		context.AbortWithStatusJSON(401, gin.H{"error": "You need to be a participant of the trip to perform this action"})
		return
	}

	context.Next()
}

func retriveTripAndUser(context *gin.Context, trip *models.Trip, user *models.User) bool {
	currentUser, exist := utils.GetCurrentUser(context)
	if !exist {
		context.AbortWithStatusJSON(401, gin.H{"error": "Unauthorized"})
		return true
	}

	tripId := context.Param("id")
	if tripId == "" {
		context.AbortWithStatusJSON(400, gin.H{"error": "Invalid trip ID"})
		return true
	}

	tripIdUint, err := strconv.ParseUint(tripId, 10, 64)
	if err != nil {
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
