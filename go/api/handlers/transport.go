package handlers

import (
	"challenge-flutter-go/api/errorHandlers"
	"challenge-flutter-go/api/responses"
	"challenge-flutter-go/api/utils"
	"challenge-flutter-go/models"
	"challenge-flutter-go/repository"
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

type TransportHandler struct {
	Repository     repository.TransportRepository
	TripRepository repository.TripRepository
}

// Add a transport to a trip
func (handler *TransportHandler) AddTransportToTrip(context *gin.Context) {
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

	trip, err := handler.TripRepository.Get(id)

	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	isUserHasRights := handler.TripRepository.HasEditRight(trip, currentUser)

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

	var transport = models.Transport{
		TripID:        trip.ID,
		TransportType: models.TransportTypeCar,
		StartDate:     startDate,
		EndDate:       endDate,
		StartAddress:  requestBody.StartAddress,
		EndAddress:    requestBody.EndAddress,
	}

	var transportCreated, errTransport = handler.Repository.AddTransport(trip, transport)

	if errTransport != nil {
		errorHandlers.HandleGormErrors(errTransport, context)
		return
	}

	transportResponse := responses.TransportResponse{
		ID:            transportCreated.ID,
		TransportType: transportCreated.TransportType,
		StartDate:     transportCreated.StartDate.Format(time.RFC3339),
		EndDate:       transportCreated.EndDate.Format(time.RFC3339),
		StartAddress:  transportCreated.StartAddress,
		EndAddress:    transportCreated.EndAddress,
	}

	context.JSON(http.StatusCreated, transportResponse)
}

// Delete a transport from a trip
func (handler *TransportHandler) DeleteTransportFromTrip(context *gin.Context) {
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

	trip, err := handler.TripRepository.Get(id)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	// Check si l'user à le droit (owner ou editor)
	isUserHasRights := handler.TripRepository.HasEditRight(trip, currentUser)

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

	context.Status(http.StatusNoContent)
}
