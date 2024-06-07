package handlers

import (
	"challenge-flutter-go/api/errorHandlers"
	"challenge-flutter-go/api/requests"
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

// @Summary		Create a new transport on trip
// @Description	Create a new transport & associate it with the trip
// @Tags			transport
// @Accept			json
// @Produce		json
// @Security		BearerAuthz
// @Param			id	path		string	true	"ID of the trip"
// @Success		201		{object}	[]responses.TransportResponse
// @Failure		400		{object}	error
// @Failure		401		{object}	error
// @Router			/trips/{id}/transports [post]
func (handler *TransportHandler) GetAllFromTrip(context *gin.Context) {
	id := context.Param("id")
	if id == "" {
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	currentUser, exist := utils.GetCurrentUser(context)
	if !exist {
		context.Status(http.StatusUnauthorized)
		return
	}

	trip, err := handler.TripRepository.Get(id)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	currentUserCanViewTrip := handler.TripRepository.HasViewRight(trip, currentUser)
	if !currentUserCanViewTrip {
		context.Status(http.StatusUnauthorized)
	}

	transports := trip.Transports

	var transportsResponse []responses.TransportResponse = make([]responses.TransportResponse, len(transports))
	for i, transport := range transports {
		var nullableMeetingTime string = ""
		if (transport.MeetingTime != time.Time{}) {
			nullableMeetingTime = transport.MeetingTime.Format(time.RFC3339)
		}
		transportsResponse[i] = responses.TransportResponse{
			ID:             transport.ID,
			TransportType:  transport.TransportType,
			StartDate:      transport.StartDate.Format(time.RFC3339),
			EndDate:        transport.EndDate.Format(time.RFC3339),
			StartAddress:   transport.StartAddress,
			EndAddress:     transport.EndAddress,
			MeetingAddress: transport.MeetingAddress,
			MeetingTime:    nullableMeetingTime,
		}
	}

	context.JSON(http.StatusOK, transportsResponse)
}

// @Summary		CreateOnTrip a new transport on trip
// @Description	CreateOnTrip a new transport & associate it with the trip
// @Tags			transport
// @Accept			json
// @Produce		json
// @Security		BearerAuth
// @Param			body	body		requests.TransportCreateBody	true	"Body of the transport"
// @Success		201		{object}	responses.TransportResponse
// @Failure		400		{object}	error
// @Failure		401		{object}	error
// @Router			/trips/{id}/transports [post]
func (handler *TransportHandler) CreateOnTrip(context *gin.Context) {
	id := context.Param("id")
	if id == "" {
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	currentUser, exist := utils.GetCurrentUser(context)
	if !exist {
		context.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	var requestBody requests.TransportCreateBody
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

	var meetingTime time.Time

	if requestBody.MeetingTime != "" {
		var meetingTimeParseError error
		meetingTime, meetingTimeParseError = time.Parse(time.RFC3339, requestBody.MeetingTime)
		if meetingTimeParseError != nil {
			context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid meeting time"})
			return
		}
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

	var transport = models.Transport{
		TripID:         trip.ID,
		TransportType:  models.TransportType(requestBody.TransportType),
		StartDate:      startDate,
		EndDate:        endDate,
		StartAddress:   requestBody.StartAddress,
		EndAddress:     requestBody.EndAddress,
		MeetingAddress: requestBody.MeetingAddress,
		MeetingTime:    meetingTime,
	}

	isValid := transport.IsTransportTypeValid(context)
	if !isValid {
		return
	}

	var errTransport = handler.Repository.Create(&transport)

	if errTransport != nil {
		errorHandlers.HandleGormErrors(errTransport, context)
		return
	}

	transportResponse := responses.TransportResponse{
		ID:             transport.ID,
		TransportType:  transport.TransportType,
		StartDate:      transport.StartDate.Format(time.RFC3339),
		EndDate:        transport.EndDate.Format(time.RFC3339),
		StartAddress:   transport.StartAddress,
		EndAddress:     transport.EndAddress,
		MeetingAddress: transport.MeetingAddress,
		MeetingTime:    transport.MeetingTime.Format(time.RFC3339),
	}

	context.JSON(http.StatusCreated, transportResponse)
}

// @Summary		Delete a transport from a trip
// @Description	Delete a transport from a trip
// @Tags			transport
// @Accept			json
// @Produce		json
// @Security		BearerAuth
// @Param			transportID	path	string	true	"ID of the transport"
// @Success		204		{object}	error
// @Failure		400		{object}	error
// @Failure		401		{object}	error
// @Failure		404		{object}	error
// @Router			/trips/{id}/transports/{transportID} [delete]
func (handler *TransportHandler) DeleteTransport(context *gin.Context) {
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

	deleteError := handler.Repository.Delete(transportID)
	if deleteError != nil {
		errorHandlers.HandleGormErrors(deleteError, context)
		return
	}

	context.Status(http.StatusNoContent)
}
