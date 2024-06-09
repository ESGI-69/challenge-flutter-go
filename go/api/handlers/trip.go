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

	currentUser, _ := utils.GetCurrentUser(context)

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
		ID:           createdTrip.ID,
		Name:         createdTrip.Name,
		Country:      createdTrip.Country,
		City:         createdTrip.City,
		StartDate:    createdTrip.StartDate.Format(time.RFC3339),
		EndDate:      createdTrip.EndDate.Format(time.RFC3339),
		Participants: utils.UserToParticipantWithRole(createdTrip.Viewers, createdTrip.Editors, createdTrip.Owner),
		InviteCode:   createdTrip.InviteCode,
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
	currentUser, _ := utils.GetCurrentUser(context)

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
			Participants: utils.UserToParticipantWithRole(trip.Viewers, trip.Editors, trip.Owner),
			InviteCode:   trip.InviteCode,
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
	tripId := context.Param("id")

	trip, _ := handler.Repository.Get(tripId)

	responseTrip := responses.TripResponse{
		ID:           trip.ID,
		Name:         trip.Name,
		Country:      trip.Country,
		City:         trip.City,
		StartDate:    trip.StartDate.Format(time.RFC3339),
		EndDate:      trip.EndDate.Format(time.RFC3339),
		Participants: utils.UserToParticipantWithRole(trip.Viewers, trip.Editors, trip.Owner),
		InviteCode:   trip.InviteCode,
	}

	context.JSON(http.StatusOK, responseTrip)
}

// @Summary Update a trip
// @Description Update a trip if the current has the right permissions
// @Tags trips
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "ID of the trip"
// @Param body body requests.TripUpdateBody true "Body of the trip"
// @Success 200 {object} responses.TripResponse
// @Failure 400 {object} error
// @Failure 401 {object} error
// @Failure 404 {object} error
// @Router /trips/{id} [patch]
func (handler *TripHandler) Update(context *gin.Context) {
	tripId := context.Param("id")

	var requestBody requests.TripUpdateBody
	isBodyValid := utils.Deserialize(&requestBody, context)
	if !isBodyValid {
		return
	}

	trip, _ := handler.Repository.Get(tripId)

	if requestBody.Name != "" {
		trip.Name = requestBody.Name
	}

	if requestBody.Country != "" {
		trip.Country = requestBody.Country
	}

	if requestBody.City != "" {
		trip.City = requestBody.City
	}

	if requestBody.StartDate != "" {
		startDate, startDateParseError := time.Parse(time.RFC3339, requestBody.StartDate)
		if startDateParseError != nil {
			context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid start date"})
			return
		}
		trip.StartDate = startDate
	}

	if requestBody.EndDate != "" {
		endDate, endDateParseError := time.Parse(time.RFC3339, requestBody.EndDate)
		if endDateParseError != nil {
			context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid end date"})
			return
		}
		trip.EndDate = endDate
	}

	updateError := handler.Repository.Update(&trip)
	if updateError != nil {
		errorHandlers.HandleGormErrors(updateError, context)
		return
	}

	responseTrip := responses.TripResponse{
		ID:           trip.ID,
		Name:         trip.Name,
		Country:      trip.Country,
		City:         trip.City,
		StartDate:    trip.StartDate.Format(time.RFC3339),
		EndDate:      trip.EndDate.Format(time.RFC3339),
		Participants: utils.UserToParticipantWithRole(trip.Viewers, trip.Editors, trip.Owner),
		InviteCode:   trip.InviteCode,
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
//	@Param			inviteCode	query	string	true	"Invite code of the trip"
//	@Success		200	{object}	responses.TripResponse
//	@Failure		400	{object}	error
//	@Failure		401	{object}	error
//	@Router			/trips/join [post]
func (handler *TripHandler) Join(context *gin.Context) {
	// Retrive the invite code from the query parameters
	inviteCode := context.Query("inviteCode")

	currentUser, _ := utils.GetCurrentUser(context)

	trip, err := handler.Repository.GetByInviteCode(inviteCode)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	currentUserRole := handler.Repository.GetUserTripRole(trip, currentUser)

	if currentUserRole != responses.ParticipantTripRoleNone {
		context.JSON(http.StatusBadRequest, gin.H{"error": "User is already part of the trip"})
		return
	}

	handler.Repository.AddViewer(&trip, currentUser)

	responseTrip := responses.TripResponse{
		ID:           trip.ID,
		Name:         trip.Name,
		Country:      trip.Country,
		City:         trip.City,
		StartDate:    trip.StartDate.Format(time.RFC3339),
		EndDate:      trip.EndDate.Format(time.RFC3339),
		Participants: utils.UserToParticipantWithRole(trip.Viewers, trip.Editors, trip.Owner),
		InviteCode:   trip.InviteCode,
	}

	context.JSON(http.StatusOK, responseTrip)
}

// @Summary Leave a trip
// @Description Leave a trip
// @Tags trips
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "ID of the trip"
// @Success 204
// @Failure 400 {object} error
// @Failure 401 {object} error
// @Router /trips/{id}/leave [post]
func (handler *TripHandler) Leave(context *gin.Context) {
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

	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	currentUserRole := handler.Repository.GetUserTripRole(trip, currentUser)

	if currentUserRole == responses.ParticipantTripRoleOwner {
		context.JSON(http.StatusUnauthorized, gin.H{"error": "Owner cannot leave the trip"})
		return
	}

	if currentUserRole == responses.ParticipantTripRoleNone {
		context.JSON(http.StatusUnauthorized, gin.H{"error": "User is not part of the trip"})
		return
	}

	if currentUserRole == responses.ParticipantTripRoleEditor {
		handler.Repository.RemoveEditor(&trip, currentUser)
	}

	if currentUserRole == responses.ParticipantTripRoleViewer {
		handler.Repository.RemoveViewer(&trip, currentUser)
	}

	context.Status(http.StatusNoContent)
}
