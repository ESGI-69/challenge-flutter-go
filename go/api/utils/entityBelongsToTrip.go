package utils

import (
	"challenge-flutter-go/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func EntityBelongsToTrip(context *gin.Context, entity models.TripEntity) bool {
	tripIDStr := context.Param("id")
	tripID, err := strconv.ParseUint(tripIDStr, 10, 32)
	if err != nil {
		context.JSON(http.StatusBadRequest, gin.H{"error": "Invalid trip ID"})
		context.Abort()
		return false
	}

	if entity.GetTripID() == uint(tripID) {
		return true
	}
	return false
}
