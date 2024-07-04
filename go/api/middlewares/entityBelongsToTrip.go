package middlewares

import (
	"challenge-flutter-go/database"
	"challenge-flutter-go/logger"
	"challenge-flutter-go/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func init() {
	databaseInstance = database.GetInstance()
}

func TransportBelongsToTrip(context *gin.Context) {
	tripIDStr := context.Param("id")
	tripID, err := strconv.ParseUint(tripIDStr, 10, 32)
	if err != nil {
		logger.Error("Invalid trip ID")
		context.JSON(http.StatusBadRequest, gin.H{"error": "Invalid trip ID" + tripIDStr})
		context.Abort()
	}
	transportID := context.Param("transportID")

	var transport models.Transport
	errDB := databaseInstance.Where("trip_id = ? AND id = ?", tripID, transportID).First(&transport).Error
	if errDB != nil {
		logger.Error("Transport not found")
		context.AbortWithStatusJSON(404, gin.H{"error": "Transport " + transportID + " not found"})
		return
	}

	logger.Info("Transport " + transportID + " belongs to trip " + tripIDStr)
	context.Next()
}

func ParticipantBelongsToTrip(context *gin.Context) {
	tripIDStr := context.Param("id")
	tripID, err := strconv.ParseUint(tripIDStr, 10, 32)
	if err != nil {
		logger.Error("Invalid trip ID " + tripIDStr)
		context.JSON(http.StatusBadRequest, gin.H{"error": "Invalid trip ID"})
		context.Abort()
	}
	participantID := context.Param("participantId")

	var participant models.User
	errDB := databaseInstance.Where("trip_id = ? AND id = ?", tripID, participantID).First(&participant).Error
	if errDB != nil {
		logger.Error("Participant " + participantID + " not found")
		context.AbortWithStatusJSON(404, gin.H{"error": "Participant not found"})
		return
	}

	logger.Info("Participant " + participantID + " belongs to trip " + tripIDStr)
	context.Next()
}

func AccommodationBelongsToTrip(context *gin.Context) {
	tripIDStr := context.Param("id")
	tripID, err := strconv.ParseUint(tripIDStr, 10, 32)
	if err != nil {
		logger.Error("Invalid trip ID " + tripIDStr)
		context.JSON(http.StatusBadRequest, gin.H{"error": "Invalid trip ID"})
		context.Abort()
	}
	accommodationID := context.Param("accommodationID")

	var accommodation models.Accommodation
	errDB := databaseInstance.Where("trip_id = ? AND id = ?", tripID, accommodationID).First(&accommodation).Error
	if errDB != nil {
		logger.Error("Accommodation " + accommodationID + " not found")
		context.AbortWithStatusJSON(404, gin.H{"error": "Transport not found"})
		return
	}

	logger.Info("Accommodation " + accommodationID + " belongs to trip " + tripIDStr)
	context.Next()
}

func NoteBelongsToTrip(context *gin.Context) {
	tripIDStr := context.Param("id")
	tripID, err := strconv.ParseUint(tripIDStr, 10, 32)
	if err != nil {
		logger.Error("Invalid trip ID " + tripIDStr)
		context.JSON(http.StatusBadRequest, gin.H{"error": "Invalid trip ID"})
		context.Abort()
	}
	noteID := context.Param("noteID")

	var note models.Note
	errDB := databaseInstance.Where("trip_id = ? AND id = ?", tripID, noteID).First(&note).Error
	if errDB != nil {
		logger.Error("Note " + noteID + " not found")
		context.AbortWithStatusJSON(404, gin.H{"error": "Transport not found"})
		return
	}

	logger.Info("Note " + noteID + " belongs to trip " + tripIDStr)
	context.Next()
}

func DocumentBelongsToTrip(context *gin.Context) {
	tripIDStr := context.Param("id")
	tripID, err := strconv.ParseUint(tripIDStr, 10, 32)
	if err != nil {
		logger.Error("Invalid trip ID " + tripIDStr)
		context.JSON(http.StatusBadRequest, gin.H{"error": "Invalid trip ID"})
		context.Abort()
	}
	documentID := context.Param("documentID")

	var document models.Document
	errDB := databaseInstance.Where("trip_id = ? AND id = ?", tripID, documentID).First(&document).Error
	if errDB != nil {
		logger.Error("Document " + documentID + " not found")
		context.AbortWithStatusJSON(404, gin.H{"error": "Transport not found"})
		return
	}

	logger.Info("Document " + documentID + " belongs to trip " + tripIDStr)
	context.Next()
}

func PhotoBelongsToTrip(context *gin.Context) {
	tripIDStr := context.Param("id")
	tripID, err := strconv.ParseUint(tripIDStr, 10, 32)
	if err != nil {
		logger.Error("Invalid trip ID " + tripIDStr)
		context.JSON(http.StatusBadRequest, gin.H{"error": "Invalid trip ID"})
		context.Abort()
	}
	photoID := context.Param("photoID")

	var photo models.Photo
	errDB := databaseInstance.Where("trip_id = ? AND id = ?", tripID, photoID).First(&photo).Error
	if errDB != nil {
		logger.Error("Photo " + photoID + " not found")
		context.AbortWithStatusJSON(404, gin.H{"error": "Transport not found"})
		return
	}

	logger.Info("Photo " + photoID + " belongs to trip " + tripIDStr)
	context.Next()
}
