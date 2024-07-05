package handlers

import (
	"challenge-flutter-go/api/errorHandlers"
	"challenge-flutter-go/api/responses"
	"challenge-flutter-go/api/utils"
	"challenge-flutter-go/logger"
	"challenge-flutter-go/models"
	"challenge-flutter-go/repository"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

type PhotoHandler struct {
	Repository     repository.PhotoRepository
	TripRepository repository.TripRepository
}

// @Summary		Get all photos of a trip
// @Description	Get all photos of a trip
// @Tags			photo
// @Accept			json
// @Produce		json
// @Security		BearerAuth
// @Param			id		path		string	true	"ID of the trip"
// @Success		200		{object}	[]responses.PhotoResponse
// @Failure		400		{object}	error
// @Failure		401		{object}	error
// @Router			/trips/{id}/photos [get]
func (handler *PhotoHandler) GetPhotosOfTrip(context *gin.Context) {
	tripId := context.Param("id")

	photos, err := handler.Repository.GetPhotos(tripId)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	photoResponses := make([]responses.PhotoResponse, len(photos))
	for i, photo := range photos {
		photoResponses[i] = responses.PhotoResponse{
			ID:          photo.ID,
			Title:       photo.Title,
			Description: photo.Description,
			CreatedAt:   photo.CreatedAt.Format(time.RFC3339),
			UpdateAt:    photo.UpdatedAt.Format(time.RFC3339),
			Owner: responses.UserResponse{
				ID:       photo.Owner.ID,
				Username: photo.Owner.Username,
			},
		}
	}
	context.JSON(http.StatusOK, photoResponses)
	logger.ApiInfo(context, "Get all photos from trip "+tripId)
}

// @Summary		Create a new photo on trip
// @Description	Create a new photo on trip
// @Tags			photo
// @Accept			multipart/form-data
// @Produce		json
// @Security		BearerAuth
// @Param			id		path		string	true	"ID of the trip"
// @Param			title		formData	string	true	"Title of the photo"
// @Param			description	formData	string	false	"Description of the photo"
// @Param			photo	formData	file	true	"Photo file"
// @Success		200		{object}	responses.PhotoResponse
// @Failure		400		{object}	error
// @Failure		401		{object}	error
// @Router			/trips/{id}/photos [post]
func (handler *PhotoHandler) CreatePhoto(context *gin.Context) {
	context.Request.Body = http.MaxBytesReader(context.Writer, context.Request.Body, 10<<20)

	tripIdStr := context.Param("id")
	tripId, _ := strconv.ParseUint(tripIdStr, 10, 32)

	title := context.PostForm("title")
	description := context.PostForm("description")

	file, errFile := context.FormFile("photo")
	if errFile != nil {
		logger.ApiWarning(context, "Photo is missing on request")
		context.JSON(http.StatusBadRequest, gin.H{"error": "Photo is missing on request"})
	}

	if file.Size > 5<<20 {
		logger.ApiWarning(context, "File size exceeds limit of 5 MB")
		context.JSON(http.StatusBadRequest, gin.H{"error": "File size exceeds limit of 5 MB"})
		return
	}

	filePath, errFilePath := utils.SaveUploadedFile(file, "photo", title)
	if errFilePath != nil {
		logger.ApiError(context, "Error saving file: "+filePath)
		context.JSON(http.StatusInternalServerError, gin.H{"error": "Error saving file"})
		return
	}

	currentUser, _ := utils.GetCurrentUser(context)

	var photo = models.Photo{
		Title:       title,
		Description: description,
		TripID:      uint(tripId),
		Path:        filePath,
		OwnerID:     currentUser.ID,
	}

	err := handler.Repository.Create(&photo)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	photoResponse := responses.PhotoResponse{
		ID:          photo.ID,
		Title:       photo.Title,
		Description: photo.Description,
		CreatedAt:   photo.CreatedAt.Format(time.RFC3339),
		UpdateAt:    photo.UpdatedAt.Format(time.RFC3339),
		Owner: responses.UserResponse{
			ID:       photo.Owner.ID,
			Username: photo.Owner.Username,
		},
	}

	context.JSON(200, photoResponse)
	logger.ApiInfo(context, "Create a photo "+photo.Path+" on trip "+tripIdStr)
}

// @Summary      Download a photo
// @Description  Download a photo
// @Tags         photo
// @Accept       json
// @Produce      application/octet-stream
// @Security     BearerAuth
// @Param        id          path      string  true  "ID of the trip"
// @Param        photoID  path      string  true  "ID of the photo"
// @Success      200         {file}    true    "A file stream of the photo"
// @Failure      400         {object}  error
// @Failure      401         {object}  error
// @Failure      404         {object}  error
// @Router       /trips/{id}/photos/{photoID}/download [get]
func (handler *PhotoHandler) DownloadPhoto(context *gin.Context) {
	photoID := context.Param("photoID")

	photo, errPhoto := handler.Repository.Get(photoID)
	if errPhoto != nil {
		errorHandlers.HandleGormErrors(errPhoto, context)
		return
	}

	tripID := context.Param("id")
	tripIDUint, _ := strconv.ParseUint(tripID, 10, 32)

	if photo.TripID != uint(tripIDUint) {
		logger.ApiError(context, "Photo does not belong to the trip")
		context.JSON(http.StatusForbidden, gin.H{"error": "Photo does not belong to the trip"})
		return
	}

	filepath, errFilePath := utils.GetFilePath("photo", photo.Path)
	if errFilePath != nil {
		logger.ApiError(context, "Failed to get file path "+photo.Path)
		context.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get file path"})
		return
	}
	context.Header("Content-Disposition", "attachment; filename=\""+photo.Path+"\"")
	context.File(filepath)
	logger.ApiInfo(context, "Download a photo "+photo.Path)
}

// @Summary		Delete a photo from trip
// @Description	Delete a photo from the trip
// @Tags			photo
// @Accept			json
// @Produce		json
// @Security		BearerAuth
// @Param			id			path		string	true	"ID of the trip"
// @Param			photoID	path		string	true	"ID of the photo"
// @Success		204			{object}	error
// @Failure		400			{object}	error
// @Failure		401			{object}	error
// @Failure		404			{object}	error
// @Router			/trips/{id}/photos/{photoID} [delete]
func (handler *PhotoHandler) DeletePhotoFromTrip(context *gin.Context) {
	photoID := context.Param("photoID")
	if photoID == "" {
		logger.ApiWarning(context, "No photo ID provided")
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	currentUser, _ := utils.GetCurrentUser(context)
	photo, errPhoto := handler.Repository.Get(photoID)

	if errPhoto != nil {
		errorHandlers.HandleGormErrors(errPhoto, context)
		return
	}

	if (photo.OwnerID != currentUser.ID) || (photo.Trip.OwnerID != currentUser.ID) {
		logger.ApiError(context, "User is not the owner of the photo or the trip")
		context.JSON(http.StatusForbidden, gin.H{"error": "User is not the owner of the photo or the trip"})
		return
	}

	err := handler.Repository.DeletePhoto(photoID)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	context.JSON(http.StatusNoContent, gin.H{})
	logger.ApiInfo(context, "Delete a photo "+photoID)
}
