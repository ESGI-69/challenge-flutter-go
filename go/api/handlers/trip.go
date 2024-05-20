package handlers

import (
	"challenge-flutter-go/api/errorHandlers"
	"challenge-flutter-go/api/utils"
	"challenge-flutter-go/models"
	"challenge-flutter-go/repository"
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

type TripHandler struct {
	Repository repository.TripRepository
}

// Create a new trip & associate it with the current user
func (handler *TripHandler) Create(context *gin.Context) {
	type RequestBody struct {
		Name      string `json:"name" binding:"required"`
		Country   string `json:"country" binding:"required"`
		City      string `json:"city" binding:"required"`
		StartDate string `json:"startDate" binding:"required"`
		EndDate   string `json:"endDate" binding:"required"`
	}

	var requestBody RequestBody
	isBodyValid := utils.Deserialize(&requestBody, context)
	if !isBodyValid {
		return
	}

	currentUser, exist := utils.GetCurrentUser(context)
	if !exist {
		return
	}

	startDate, startDateParseError := time.Parse(time.RFC3339, requestBody.StartDate)
	if startDateParseError != nil {
		fmt.Println(startDateParseError)
		context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid start date"})
		return
	}

	endDate, endDateParseError := time.Parse(time.RFC3339, requestBody.EndDate)
	if endDateParseError != nil {
		context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid end date"})
		return
	}

	trip := models.Trip{
		Name:      requestBody.Name,
		Country:   requestBody.Country,
		City:      requestBody.City,
		Owner:     currentUser,
		StartDate: startDate,
		EndDate:   endDate,
	}

	createdTrip, err := handler.Repository.Create(trip)

	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	context.JSON(http.StatusCreated, createdTrip)
}

// Join an existing trip using its inviteCode and associate it with the current user
func (handler *TripHandler) Join(context *gin.Context) {
	id := context.Param("id")

	if id == "" {
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	currentUser, exist := utils.GetCurrentUser(context)
	if !exist {
		return
	}

	trip, err := handler.Repository.GetByInviteCode(id)

	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	err = handler.Repository.AddParticipant(trip, currentUser, models.TripParticipantRoleGuest)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	updatedTrip, err := handler.Repository.GetByInviteCode(id)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	context.JSON(http.StatusOK, updatedTrip)
}

// Add a transport to a trip
func (handler *TripHandler) AddTransport(context *gin.Context) {
	id := context.Param("id")
	if id == "" {
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	type RequestBody struct {
		StartDate     string `json:"StartDate" binding:"required"`
		EndDate       string `json:"EndDate" binding:"required"`
		TransportType string `json:"TransportType" binding:"required"`
		StartAddress  string `json:"StartAddress" binding:"required"`
		EndAddress    string `json:"EndAddress" binding:"required"`
	}

	var requestBody RequestBody
	isBodyValid := utils.Deserialize(&requestBody, context)
	if !isBodyValid {
		return
	}

	startDate, startDateParseError := time.Parse(time.RFC3339, requestBody.StartDate)
	if startDateParseError != nil {
		fmt.Println(startDateParseError)
		context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid start date"})
		return
	}

	endDate, endDateParseError := time.Parse(time.RFC3339, requestBody.EndDate)
	if endDateParseError != nil {
		context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid end date"})
		return
	}

	currentUser, exist := utils.GetCurrentUser(context)
	if !exist {
		context.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	trip, err := handler.Repository.Get(id)

	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	participants, err := handler.Repository.GetParticipants(trip)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	// Check si l'user à le droit (owner ou editor)
	isUserHasRights := false
	for _, participant := range participants {
		if participant.UserID == currentUser.ID {
			if participant.Role == "EDITOR" {
				isUserHasRights = true
			}
			break
		}
	}

	if !isUserHasRights {
		if trip.OwnerID != currentUser.ID {
			context.AbortWithStatus(http.StatusUnauthorized)
			return
		}
	}

	if requestBody.TransportType != string(models.TransportTypeCar) {
		context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid transport type"})
		return
	}

	transport := models.Transport{
		TripID:        trip.ID,
		TransportType: models.TransportTypeCar,
		StartDate:     startDate,
		EndDate:       endDate,
		StartAddress:  requestBody.StartAddress,
		EndAddress:    requestBody.EndAddress,
	}

	err = handler.Repository.AddTransport(trip, transport)

	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	context.JSON(http.StatusCreated, transport)
}

// Delete a transport from a trip
func (handler *TripHandler) DeleteTransport(context *gin.Context) {
	id := context.Param("id")
	if id == "" {
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	transportID := context.Param("transportID")
	if transportID == "" {
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	currentUser, exist := utils.GetCurrentUser(context)
	if !exist {
		context.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	trip, err := handler.Repository.Get(id)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	participants, err := handler.Repository.GetParticipants(trip)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	// Check si l'user à le droit (owner ou editor)
	isUserHasRights := false
	for _, participant := range participants {
		if participant.UserID == currentUser.ID {
			if participant.Role == "EDITOR" {
				isUserHasRights = true
			}
			break
		}
	}

	if !isUserHasRights {
		if trip.OwnerID != currentUser.ID {
			context.AbortWithStatus(http.StatusUnauthorized)
			return
		}
	}

	transports, err := handler.Repository.GetTransports(trip)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	// Delete the transport
	isTransportFound := false
	for _, transport := range transports {
		if fmt.Sprint(transport.ID) == transportID {
			isTransportFound = true
			// Quand on delete un transport, on ne le Delete pas vraiment de la BD, on set le deleted_at à la date actuelle mais il est ignoré dans les requêtes
			err = handler.Repository.DeleteTransport(trip, transport.ID)
			if err != nil {
				errorHandlers.HandleGormErrors(err, context)
				return
			}
			break
		}
	}
	if !isTransportFound {
		context.AbortWithStatusJSON(http.StatusNotFound, gin.H{"error": "Transport not found"})
		return
	}
	context.JSON(http.StatusOK, gin.H{"message": "Transport deleted"})

}
