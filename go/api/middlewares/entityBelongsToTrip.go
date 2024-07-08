package middlewares

import (
	"challenge-flutter-go/database"
	"challenge-flutter-go/logger"
	"challenge-flutter-go/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm/clause"
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
	participantIdUint, err := strconv.ParseUint(participantID, 10, 32)

	if err != nil {
		logger.Error("Invalid participant ID " + participantID)
		context.JSON(http.StatusBadRequest, gin.H{"error": "Invalid participant ID"})
		context.AbortWithStatusJSON(400, gin.H{"error": "Invalid participant ID"})
	}

	var trip models.Trip
	var errDB = databaseInstance.Where("id = ?", tripID).Preload(clause.Associations).First(&trip).Error

	if errDB != nil {
		logger.Error("Trip " + tripIDStr + " not found")
		context.AbortWithStatusJSON(404, gin.H{"error": "Trip not found"})
		return
	}

	// Check if the user is in a liason table between the trip and the user
	var isParticipant bool = false

	if trip.OwnerID == uint(participantIdUint) {
		isParticipant = true
	} else {
		for _, viewers := range trip.Viewers {
			if viewers.ID == uint(participantIdUint) {
				isParticipant = true
				break
			}
		}
		for _, editors := range trip.Editors {
			if editors.ID == uint(participantIdUint) {
				isParticipant = true
				break
			}
		}
	}

	if !isParticipant {
		logger.Error("Participant " + participantID + " not found in trip " + tripIDStr)
		context.AbortWithStatusJSON(404, gin.H{"error": "Participant not found in trip"})
		return
	}

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

	context.Next()
}
