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
	"os"
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
		logger.ApiError(context, "Invalid trip start date "+requestBody.StartDate)
		context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid start date"})
		return
	}

	endDate, endDateParseError := time.Parse(time.RFC3339, requestBody.EndDate)
	if endDateParseError != nil {
		logger.ApiError(context, "Invalid trip end date "+requestBody.EndDate)
		context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid end date"})
		return
	}

	//Get an image from google maps api for the trip
	image, err := utils.GetPhotoURIFromPlaceName(requestBody.City + ", " + requestBody.Country)
	if err != nil {
		logger.ApiError(context, "Error getting image from google maps api")
	}

	var uniqueTitleString string
	filePath, err := utils.DownloadImageFromURL(context, image)
	if err != nil {
		logger.ApiError(context, "Error downloading image from URL")
	} else {
		uniqueTitleString = filePath + ".jpg"
	}

	trip := models.Trip{
		Name:      requestBody.Name,
		Country:   requestBody.Country,
		City:      requestBody.City,
		Owner:     currentUser,
		StartDate: startDate,
		EndDate:   endDate,
		PhotoUrl:  uniqueTitleString,
	}

	err = handler.Repository.Create(&trip)

	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
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

	context.JSON(http.StatusCreated, responseTrip)
	logger.ApiInfo(context, "Trip "+string(rune(trip.ID))+" created")
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
	logger.ApiInfo(context, "Get all trips")
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
	logger.ApiInfo(context, "Get trip "+tripId)
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
			logger.ApiError(context, "Invalid trip update start date "+requestBody.StartDate)
			context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid start date"})
			return
		}
		trip.StartDate = startDate
	}

	if requestBody.EndDate != "" {
		endDate, endDateParseError := time.Parse(time.RFC3339, requestBody.EndDate)
		if endDateParseError != nil {
			logger.ApiError(context, "Invalid trip update end date "+requestBody.EndDate)
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
	logger.ApiInfo(context, "Trip "+tripId+" updated")
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

	if trip.UserHasViewRight(&currentUser) {
		logger.ApiWarning(context, "User "+string(rune(currentUser.ID))+" is already part of the trip")
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
	logger.ApiInfo(context, "User "+string(rune(currentUser.ID))+" joined trip "+string(rune(trip.ID)))
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

	currentUser, _ := utils.GetCurrentUser(context)

	trip, _ := handler.Repository.Get(id)

	if trip.UserIsOwner(&currentUser) {
		logger.ApiWarning(context, "User "+string(rune(currentUser.ID))+" cannot leave the trip "+id+" because he is the owner")
		context.JSON(http.StatusUnauthorized, gin.H{"error": "Owner cannot leave the trip"})
		return
	}

	if trip.UserIsEditor(&currentUser) {
		handler.Repository.RemoveEditor(&trip, currentUser)
	}

	if trip.UserIsViewer(&currentUser) {
		handler.Repository.RemoveViewer(&trip, currentUser)
	}

	context.Status(http.StatusNoContent)
	logger.ApiInfo(context, "User "+string(rune(currentUser.ID))+" left trip "+id)
}

// @Summary Delete a trip
// @Description Delete a trip
// @Tags trips
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "ID of the trip"
// @Success 204
// @Failure 400 {object} error
// @Failure 401 {object} error
// @Router /trips/{id} [delete]
func (handler *TripHandler) Delete(context *gin.Context) {
	tripId := context.Param("id")

	deleteError := handler.Repository.Delete(tripId)
	if deleteError != nil {
		errorHandlers.HandleGormErrors(deleteError, context)
		return
	}

	context.Status(http.StatusNoContent)
	logger.ApiInfo(context, "Delete trip "+tripId)
}

// @Summary      Download trip banner
// @Description  Download the banner image of a trip
// @Tags         trip
// @Accept       json
// @Produce      application/octet-stream
// @Security     BearerAuth
// @Param        id          path      string  true  "ID of the trip"
// @Success      200         {file}    true    "A file stream of the trip banner"
// @Failure      400         {object}  error
// @Failure      401         {object}  error
// @Failure      404         {object}  error
// @Router       /trips/{id}/banner/download [get]
func (handler *TripHandler) DownloadTripBanner(context *gin.Context) {
	tripId := context.Param("id")

	trip, errTrip := handler.Repository.Get(tripId)
	if errTrip != nil {
		errorHandlers.HandleGormErrors(errTrip, context)
		return
	}

	if trip.PhotoUrl == "" {
		logger.ApiError(context, "Trip "+tripId+" does not have a banner")
		context.File("assets/default.jpg")
		return
	} else {

		bannerPath, errBannerPath := utils.GetFilePath("banner", trip.PhotoUrl)
		if errBannerPath != nil {
			logger.ApiError(context, "Failed to get banner file path "+trip.PhotoUrl)
			context.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get banner file path"})
			return
		}

		if _, err := os.Stat(bannerPath); os.IsNotExist(err) {
			logger.ApiError(context, "Banner file does not exist "+trip.PhotoUrl)
			context.JSON(http.StatusNotFound, gin.H{"error": "Banner file does not exist"})
			return
		}

		logger.ApiInfo(context, "Download trip banner")

		context.File(bannerPath)
	}

}
