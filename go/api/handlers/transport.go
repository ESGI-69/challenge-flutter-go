package handlers

import (
	"challenge-flutter-go/api/errorHandlers"
	"challenge-flutter-go/api/requests"
	"challenge-flutter-go/api/responses"
	"challenge-flutter-go/api/utils"
	"challenge-flutter-go/logger"
	"challenge-flutter-go/models"
	"challenge-flutter-go/repository"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
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
	transports, err := handler.Repository.GetAllFromTrip(context.Param("id"))
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	var transportsResponse []responses.TransportResponse = make([]responses.TransportResponse, len(transports))
	for i, transport := range transports {
		var nullableMeetingTime string = ""
		if (transport.MeetingTime != time.Time{}) {
			nullableMeetingTime = transport.MeetingTime.Format(time.RFC3339)
		}

		transportsResponse[i] = responses.TransportResponse{
			ID:               transport.ID,
			TransportType:    transport.TransportType,
			StartDate:        transport.StartDate.Format(time.RFC3339),
			EndDate:          transport.EndDate.Format(time.RFC3339),
			StartAddress:     transport.StartAddress,
			StartLatitude:    transport.StartLatitude,
			StartLongitude:   transport.StartLongitude,
			EndAddress:       transport.EndAddress,
			EndLatitude:      transport.EndLatitude,
			EndLongitude:     transport.EndLongitude,
			MeetingAddress:   transport.MeetingAddress,
			MeetingLatitude:  transport.MeetingLatitude,
			MeetingLongitude: transport.MeetingLongitude,
			MeetingTime:      nullableMeetingTime,
			Author: responses.UserResponse{
				ID:       transport.Author.ID,
				Username: transport.Author.Username,
			},
			Price: transport.Price,
		}
	}

	context.JSON(http.StatusOK, transportsResponse)
	logger.ApiInfo(context, "Get all transports from trip "+context.Param("id"))
}

// @Summary		Create a new transport on trip
// @Description	Create a new transport & associate it with the trip
// @Tags			transport
// @Accept			json
// @Produce		json
// @Security		BearerAuth
// @Param		id	path		string	true	"ID of the trip"
// @Param			body	body		requests.TransportCreateBody	true	"Body of the transport"
// @Success		201		{object}	responses.TransportResponse
// @Failure		400		{object}	error
// @Failure		401		{object}	error
// @Router			/trips/{id}/transports [post]
func (handler *TransportHandler) Create(context *gin.Context) {
	tripId := context.Param("id")

	currentUser, _ := utils.GetCurrentUser(context)

	var requestBody requests.TransportCreateBody
	isBodyValid := utils.Deserialize(&requestBody, context)
	if !isBodyValid {
		return
	}

	startDate, startDateParseError := time.Parse(time.RFC3339, requestBody.StartDate)
	if startDateParseError != nil {
		logger.ApiWarning(context, "Invalid transport start date "+requestBody.StartDate)
		context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid start date"})
		return
	}

	endDate, endDateParseError := time.Parse(time.RFC3339, requestBody.EndDate)
	if endDateParseError != nil {
		logger.ApiWarning(context, "Invalid transport end date "+requestBody.EndDate)
		context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid end date"})
		return
	}

	var meetingTime time.Time

	if requestBody.MeetingTime != "" {
		var meetingTimeParseError error
		meetingTime, meetingTimeParseError = time.Parse(time.RFC3339, requestBody.MeetingTime)
		if meetingTimeParseError != nil {
			logger.ApiWarning(context, "Invalid transport meeting time "+requestBody.MeetingTime)
			context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid meeting time"})
			return
		}
	}

	tripIdUint, _ := strconv.ParseUint(tripId, 10, 64)

	transport := models.Transport{
		Trip:           models.Trip{Model: gorm.Model{ID: uint(tripIdUint)}},
		Author:         currentUser,
		TransportType:  models.TransportType(requestBody.TransportType),
		StartDate:      startDate,
		EndDate:        endDate,
		StartAddress:   requestBody.StartAddress,
		EndAddress:     requestBody.EndAddress,
		MeetingAddress: requestBody.MeetingAddress,
		MeetingTime:    meetingTime,
		Price:          requestBody.Price,
	}

	errTransport := handler.Repository.Create(&transport)
	if errTransport != nil {
		errorHandlers.HandleGormErrors(errTransport, context)
		return
	}

	transportResponse := responses.TransportResponse{
		ID:               transport.ID,
		TransportType:    transport.TransportType,
		StartDate:        transport.StartDate.Format(time.RFC3339),
		EndDate:          transport.EndDate.Format(time.RFC3339),
		StartAddress:     transport.StartAddress,
		StartLatitude:    transport.StartLatitude,
		StartLongitude:   transport.StartLongitude,
		EndAddress:       transport.EndAddress,
		EndLatitude:      transport.EndLatitude,
		EndLongitude:     transport.EndLongitude,
		MeetingAddress:   transport.MeetingAddress,
		MeetingLatitude:  transport.MeetingLatitude,
		MeetingLongitude: transport.MeetingLongitude,
		MeetingTime:      transport.MeetingTime.Format(time.RFC3339),
		Author: responses.UserResponse{
			ID:       transport.Author.ID,
			Username: transport.Author.Username,
		},
		Price: transport.Price,
	}

	context.JSON(http.StatusCreated, transportResponse)
	logger.ApiInfo(context, "Create transport "+string(rune(transport.ID))+" on trip "+tripId)
}

// @Summary		Delete a transport from a trip
// @Description	Delete a transport from a trip
// @Tags			transport
// @Accept			json
// @Produce		json
// @Security		BearerAuth
// @Param			id	path	string	true	"ID of the trip"
// @Param			transportID	path	string	true	"ID of the transport"
// @Success		204		{object}	error
// @Failure		400		{object}	error
// @Failure		401		{object}	error
// @Failure		404		{object}	error
// @Router			/trips/{id}/transports/{transportID} [delete]
func (handler *TransportHandler) DeleteTransport(context *gin.Context) {
	transportID := context.Param("transportID")
	if transportID == "" {
		logger.ApiWarning(context, "No transport ID provided for deletion")
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	trip, _ := handler.TripRepository.Get(context.Param("id"))

	transport, getError := handler.Repository.Get(transportID)
	if getError != nil {
		errorHandlers.HandleGormErrors(getError, context)
		return
	}

	currentUser, _ := utils.GetCurrentUser(context)

	if transport.AuthorID != currentUser.ID && !trip.UserIsOwner(&currentUser) {
		logger.ApiWarning(context, "User "+currentUser.Username+" is not the author of transport "+transportID+" or owner of the trip "+context.Param("id")+", and can't delete it")
		context.AbortWithStatus(http.StatusUnauthorized)
		return
	}

	deleteError := handler.Repository.Delete(transportID)
	if deleteError != nil {
		errorHandlers.HandleGormErrors(deleteError, context)
		return
	}

	context.Status(http.StatusNoContent)
	logger.ApiInfo(context, "Delete transport "+transportID)
}
