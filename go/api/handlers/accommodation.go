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
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type AccommodationHandler struct {
	Repository     repository.AccommodationRepository
	TripRepository repository.TripRepository
}

// @Summary		Get all accommodations from a trip
// @Description	Get all accommodations associated with the trip
// @Tags			accommodation
// @Accept		json
// @Produce		json
// @Security		BearerAuth
// @Param		id	path		string	true	"ID of the trip"
// @Success		200		{object}	[]responses.AccommodationResponse
// @Failure		400		{object}	error
// @Failure		401		{object}	error
// @Router		/trips/{id}/accommodations [get]
func (handler *AccommodationHandler) GetAllFromTrip(context *gin.Context) {
	accommodations, err := handler.Repository.GetAllFromTrip(context.Param("id"))
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	var accommodationsResponse []responses.AccommodationResponse = make([]responses.AccommodationResponse, len(accommodations))
	for i, accommodation := range accommodations {
		accommodationsResponse[i] = responses.AccommodationResponse{
			ID:                accommodation.ID,
			Name:              accommodation.Name,
			Address:           accommodation.Address,
			StartDate:         accommodation.StartDate.Format(time.RFC3339),
			EndDate:           accommodation.EndDate.Format(time.RFC3339),
			BookingURL:        accommodation.BookingURL,
			AccommodationType: accommodation.AccommodationType,
			Latitude:          accommodation.Latitude,
			Longitude:         accommodation.Longitude,
		}
	}

	context.JSON(http.StatusOK, accommodationsResponse)

}

// @Summary		Create an accommodation on a trip
// @Description	Create a new accommodation associated with the trip
// @Tags			accommodation
// @Accept		json
// @Produce		json
// @Security		BearerAuth
// @Param		id	path		string	true	"ID of the trip"
// @Param		body	body		requests.AccommodationCreateBody	true	"Accommodation details"
// @Success		201		{object}	responses.AccommodationResponse
// @Failure		400		{object}	error
// @Failure		401		{object}	error
// @Router		/trips/{id}/accommodations [post]
func (handler *AccommodationHandler) Create(context *gin.Context) {
	tripId := context.Param("id")

	var requestBody requests.AccommodationCreateBody
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

	tripIdUint, _ := strconv.ParseUint(tripId, 10, 64)

	getLat, getLong, err := utils.GetGeoLocation(requestBody.Address)
	if err != nil { //A voir si on bloque la creation si l'adresse n'est pas valide
		context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid address"})
		return
	}

	var accommodation = models.Accommodation{
		Trip:              models.Trip{Model: gorm.Model{ID: uint(tripIdUint)}},
		AccommodationType: models.AccommodationType(requestBody.AccommodationType),
		StartDate:         startDate,
		EndDate:           endDate,
		Address:           requestBody.Address,
		BookingURL:        requestBody.BookingURL,
		Name:              requestBody.Name,
		Latitude:          getLat,
		Longitude:         getLong,
	}

	if !accommodation.IsAccommodationTypeValid(context) {
		return
	}

	err = handler.Repository.Create(&accommodation)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	context.JSON(http.StatusCreated, responses.AccommodationResponse{
		ID:                accommodation.ID,
		Name:              accommodation.Name,
		Address:           accommodation.Address,
		StartDate:         accommodation.StartDate.Format(time.RFC3339),
		EndDate:           accommodation.EndDate.Format(time.RFC3339),
		BookingURL:        accommodation.BookingURL,
		AccommodationType: accommodation.AccommodationType,
		Latitude:          accommodation.Latitude,
		Longitude:         accommodation.Longitude,
	})
}

// @Summary		Delete an accommodation
// @Description	Delete an accommodation associated with the trip
// @Tags			accommodation
// @Accept		json
// @Produce		json
// @Security		BearerAuth
// @Param		id	path	string	true	"ID of the trip"
// @Param		accommodationID	path	string	true	"ID of the accommodation"
// @Success		204		{object}	nil
// @Failure		400		{object}	error
// @Failure		401		{object}	error
// @Router		/trips/{id}/accommodations/{accommodationID} [delete]
func (handler *AccommodationHandler) DeleteAccommodation(context *gin.Context) {
	accommodationID := context.Param("accommodationID")
	if accommodationID == "" {
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	accommodation, err := handler.Repository.Get(accommodationID)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	tripId := context.Param("id")
	if tripId == "" {
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	parsedTripId, err := strconv.ParseUint(tripId, 10, 10)
	if err != nil {
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	if accommodation.TripID != uint(parsedTripId) {
		context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Accommodation not in the trip"})
		return
	}

	err = handler.Repository.Delete(accommodationID)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	context.Status(http.StatusNoContent)
}