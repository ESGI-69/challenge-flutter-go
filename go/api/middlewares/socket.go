package middlewares

import (
	"challenge-flutter-go/logger"
	"challenge-flutter-go/models"

	"github.com/gin-gonic/gin"
)

func SocketUserIsTripParticipant(context *gin.Context) {
	tripId := context.Query("roomId")

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
