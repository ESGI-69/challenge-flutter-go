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

type ActivityHandler struct {
	Repository     repository.ActivityRepository
	TripRepository repository.TripRepository
}

// @Summary		Get all activities from a trip
// @Description	Get all activities associated with the trip
// @Tags			activity
// @Accept		json
// @Produce		json
// @Security		BearerAuth
// @Param		id	path		string	true	"ID of the trip"
// @Success		200		{object}	[]responses.ActivityResponse
// @Failure		400		{object}	error
// @Failure		401		{object}	error
// @Router		/trips/{id}/activities [get]
func (handler *ActivityHandler) GetAllFromTrip(context *gin.Context) {
	activities, err := handler.Repository.GetAllFromTrip(context.Param("id"))
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	var activitiesResponse []responses.ActivityResponse = make([]responses.ActivityResponse, len(activities))
	for i, activity := range activities {
		activitiesResponse[i] = responses.ActivityResponse{
			ID:          activity.ID,
			Name:        activity.Name,
			Description: activity.Description,
			StartDate:   activity.StartDate.Format(time.RFC3339),
			EndDate:     activity.EndDate.Format(time.RFC3339),
			Latitude:    activity.Latitude,
			Longitude:   activity.Longitude,
			Owner: responses.UserResponse{
				ID:       activity.Owner.ID,
				Username: activity.Owner.Username,
			},
		}
	}

	context.JSON(http.StatusOK, activitiesResponse)
	logger.ApiInfo(context, "Get all activities from trip "+context.Param("id"))
}

// @Summary		Create an activity
// @Description	Create an activity associated with the trip
// @Tags			activity
// @Accept		json
// @Produce		json
// @Security		BearerAuth
// @Param		id	path		string	true	"ID of the trip"
// @Param		activity	body	requests.ActivityCreateBody	true	"Activity information"
// @Success		201		{object}	responses.ActivityResponse
// @Failure		400		{object}	error
// @Failure		401		{object}	error
// @Router		/trips/{id}/activities [post]
func (handler *ActivityHandler) Create(context *gin.Context) {
	tripId := context.Param("id")
	tripIdUint, _ := strconv.ParseUint(tripId, 10, 64)

	var requestBody requests.ActivityCreateBody
	isBodyValid := utils.Deserialize(&requestBody, context)
	if !isBodyValid {
		return
	}

	startDate, startDateParseError := time.Parse(time.RFC3339, requestBody.StartDate)
	if startDateParseError != nil {
		logger.ApiWarning(context, "Invalid start date "+requestBody.StartDate)
		context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid start date"})
		return
	}

	endDate, endDateParseError := time.Parse(time.RFC3339, requestBody.EndDate)
	if endDateParseError != nil {
		logger.ApiWarning(context, "Invalid end date "+requestBody.EndDate)
		context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid end date"})
		return
	}

	latitude, longitude, err := utils.GetGeoLocation(requestBody.Location)
	if err != nil {
		logger.ApiWarning(context, "Invalid address "+requestBody.Location)
		context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid address"})
		return
	}

	currentUser, _ := utils.GetCurrentUser(context)

	var activity = models.Activity{
		Name:        requestBody.Name,
		Description: requestBody.Description,
		Trip:        models.Trip{Model: gorm.Model{ID: uint(tripIdUint)}},
		Owner:       currentUser,
		Price:       requestBody.Price,
		StartDate:   startDate,
		EndDate:     endDate,
		Location:    requestBody.Location,
		Latitude:    latitude,
		Longitude:   longitude,
	}

	err = handler.Repository.Create(&activity)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	context.JSON(http.StatusCreated, responses.ActivityResponse{
		ID:          activity.ID,
		Name:        activity.Name,
		Description: activity.Description,
		StartDate:   activity.StartDate.Format(time.RFC3339),
		EndDate:     activity.EndDate.Format(time.RFC3339),
		Price:       activity.Price,
		Location:    activity.Location,
		Latitude:    activity.Latitude,
		Longitude:   activity.Longitude,
		Owner: responses.UserResponse{
			ID:       activity.Owner.ID,
			Username: activity.Owner.Username,
		},
	})
	logger.ApiInfo(context, "Activity "+activity.Name+" created on trip "+tripId)
}

// @Summary		Delete an activity
// @Description	Delete an activity associated with the trip
// @Tags			activity
// @Accept		json
// @Produce		json
// @Security		BearerAuth
// @Param		id	path		string	true	"ID of the trip"
// @Param		activityId	path	string	true	"ID of the activity"
// @Success		204		{object}	error
// @Failure		400		{object}	error
// @Failure		401		{object}	error
// @Router		/trips/{id}/activities/{activityId} [delete]
func (handler *ActivityHandler) Delete(context *gin.Context) {
	activityId := context.Param("activityID")

	err := handler.Repository.Delete(activityId)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	context.JSON(http.StatusNoContent, nil)
	logger.ApiInfo(context, "Activity "+activityId+" deleted")
}
