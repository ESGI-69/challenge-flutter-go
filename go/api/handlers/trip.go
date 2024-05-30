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

type TripHandler struct {
	Repository repository.TripRepository
}

// Create a new trip & associate it with the current user
//
//	@Summary		Create a new trip
//	@Description	Create a new trip & associate it with the current user
//	@Tags			trips
//	@Accept			json
//	@Produce		json
//	@Security		BearerAuth
//	@Param			body	body		requests.TripCreateBody	true	"Body of the trip"
//	@Success		201		{object}	responses.TripResponse
//	@Failure		400		{object}	error
//	@Failure		401		{object}	error
//	@Router			/trips [post]
func (handler *TripHandler) Create(context *gin.Context) {

	var requestBody requests.TripCreateBody
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

	responseTrip := responses.TripResponse{
		ID:        createdTrip.ID,
		Name:      createdTrip.Name,
		Country:   createdTrip.Country,
		City:      createdTrip.City,
		StartDate: createdTrip.StartDate.Format(time.RFC3339),
		EndDate:   createdTrip.EndDate.Format(time.RFC3339),
		Owner: responses.UserResponse{
			ID:       createdTrip.Owner.ID,
			Username: createdTrip.Owner.Username,
			Role:     string(createdTrip.Owner.Role),
		},
		Participants: []responses.UserResponse{},
	}

	context.JSON(http.StatusCreated, responseTrip)
}

// Get all trips associated with the current user
//
//	@Summary		Get all trips
//	@Description	Get all trips associated with the current user
//	@Tags			trips
//	@Accept			json
//	@Produce		json
//	@Security		BearerAuth
//	@Success		200	{array}		responses.TripResponse
//	@Failure		400	{object}	error
//	@Failure		401	{object}	error
//	@Router			/trips [get]
func (handler *TripHandler) GetAllJoined(context *gin.Context) {
	currentUser, exist := utils.GetCurrentUser(context)
	if !exist {
		return
	}

	trips, err := handler.Repository.GetAllJoined(currentUser)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	responseTrips := make([]responses.TripResponse, len(trips))
	for i, trip := range trips {
		responseTrips[i] = responses.TripResponse{
			ID:           trip.ID,
			Name:         trip.Name,
			Country:      trip.Country,
			City:         trip.City,
			StartDate:    trip.StartDate.Format(time.RFC3339),
			EndDate:      trip.EndDate.Format(time.RFC3339),
			Owner:        responses.UserResponse{ID: trip.Owner.ID, Username: trip.Owner.Username, Role: string(trip.Owner.Role)},
			Participants: []responses.UserResponse{},
		}
	}

	context.JSON(http.StatusOK, responseTrips)
}

// Get a trip by its id
//
//	@Summary		Get a trip
//	@Description	Get a trip by its id
//	@Tags			trips
//	@Accept			json
//	@Produce		json
//	@Security		BearerAuth
//	@Param			id	path		string	true	"ID of the trip"
//	@Success		200	{object}	responses.TripResponse
//	@Failure		400	{object}	error
//	@Failure		401	{object}	error
//	@Failure		404	{object}	error
//	@Router			/trips/{id} [get]
func (handler *TripHandler) Get(context *gin.Context) {
	id := context.Param("id")

	if id == "" {
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	currentUser, exist := utils.GetCurrentUser(context)
	if !exist {
		return
	}

	trip, err := handler.Repository.Get(id)

	if trip.OwnerID != currentUser.ID {
		context.AbortWithStatus(http.StatusUnauthorized)
	}

	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	responseTrip := responses.TripResponse{
		ID:        trip.ID,
		Name:      trip.Name,
		Country:   trip.Country,
		City:      trip.City,
		StartDate: trip.StartDate.Format(time.RFC3339),
		EndDate:   trip.EndDate.Format(time.RFC3339),
		Owner: responses.UserResponse{
			ID:       trip.Owner.ID,
			Username: trip.Owner.Username,
			Role:     string(trip.Owner.Role),
		},
		Participants: []responses.UserResponse{},
	}

	context.JSON(http.StatusOK, responseTrip)
}

// Join an existing trip using its inviteCode and associate it with the current user
//
//	@Summary		Join a trip
//	@Description	Join an existing trip using its inviteCode and associate it with the current user
//	@Tags			trips
//	@Accept			json
//	@Produce		json
//	@Security		BearerAuth
//	@Param			id	path		string	true	"Invite code of the trip"
//	@Success		200	{object}	responses.TripResponse
//	@Failure		400	{object}	error
//	@Failure		401	{object}	error
//	@Router			/trips/join/{id} [post]
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

	responseTrip := responses.TripResponse{
		ID:        updatedTrip.ID,
		Name:      updatedTrip.Name,
		Country:   updatedTrip.Country,
		City:      updatedTrip.City,
		StartDate: updatedTrip.StartDate.Format(time.RFC3339),
		EndDate:   updatedTrip.EndDate.Format(time.RFC3339),
		Owner: responses.UserResponse{
			ID:       updatedTrip.Owner.ID,
			Username: updatedTrip.Owner.Username,
			Role:     string(updatedTrip.Owner.Role),
		},
		Participants: []responses.UserResponse{},
	}

	context.JSON(http.StatusOK, responseTrip)
}
