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

	"github.com/gin-gonic/gin"
)

type UserHandler struct {
	Repository repository.UserRepository
}

// Get the user by his id
//
//	@Summary		Get the user
//	@Description	Get the user by his id
//	@Tags			users
//	@Accept			json
//	@Produce		json
//	@Security		BearerAuth
//	@Param			id	path		string	true	"ID of the user"
//	@Success		200	{object}	responses.UserRoleReponse
//	@Failure		400	{object}	error
//	@Failure		401	{object}	error
//	@Failure		404	{object}	error
//	@Router			/users/{id} [get]
func (handler *UserHandler) Get(context *gin.Context) {
	id := context.Param("id")

	if id == "" {
		logger.ApiError(context, "User ID missing in the get user request")
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	uintId, errUintParse := strconv.ParseUint(id, 10, 32)

	if errUintParse != nil {
		logger.ApiError(context, "User ID must be a number to get the user")
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	currentUser, _ := utils.GetCurrentUser(context)

	if currentUser.ID != uint(uintId) {
		logger.ApiError(context, "User can only get his own information")
		context.AbortWithStatus(http.StatusUnauthorized)
		return
	}

	user, err := handler.Repository.Get(id)

	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	response := responses.UserRoleReponse{
		ID:                 user.ID,
		Username:           user.Username,
		Role:               user.Role,
		ProfilePicturePath: user.ProfilePicturePath,
	}

	context.JSON(http.StatusOK, response)
	logger.ApiInfo(context, "Get user "+string(rune(user.ID)))
}

// Register a new user
//
//	@Summary		Register a new user
//	@Description	Register a new user with a username and a password
//	@Tags			users
//	@Accept			json
//	@Produce		json
//
//	@Param			user	body		requests.UserCreateBody	true	"User registration details"
//	@Success		201		{object}	responses.UserRoleReponse
//	@Failure		400		{object}	error
//	@Router			/users [post]
func (handler *UserHandler) Create(context *gin.Context) {

	var requestBody requests.UserCreateBody
	isBodyValid := utils.Deserialize(&requestBody, context)
	if !isBodyValid {
		return
	}

	user := models.User{Username: requestBody.Username, Password: requestBody.Password}
	userCreationError := handler.Repository.Create(&user)
	if userCreationError != nil {
		errorHandlers.HandleGormErrors(userCreationError, context)
		return
	}

	response := responses.UserRoleReponse{
		ID:                 user.ID,
		Username:           user.Username,
		Role:               user.Role,
		ProfilePicturePath: user.ProfilePicturePath,
	}
	context.JSON(http.StatusCreated, response)
	logger.ApiInfo(context, "User "+string(rune(user.ID))+" created")
}

// Get all the users
//
// @Summary		Get all the users as an admin
// @Description	Get all the users as an admin
// @Tags			admin
// @Accept			json
// @Produce		json
// @Security		BearerAuth
// @Success		200	{array}	responses.UserRoleReponse
// @Failure		400	{object}	error
// @Failure		401	{object}	error
// @Router			/admin/users [get]
func (handler *UserHandler) GetAll(context *gin.Context) {
	users, err := handler.Repository.GetAll()
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	responseUsers := make([]responses.UserRoleReponse, len(users))
	for i, user := range users {
		responseUsers[i] = responses.UserRoleReponse{
			ID:                 user.ID,
			Username:           user.Username,
			Role:               user.Role,
			ProfilePicturePath: user.ProfilePicturePath,
		}
	}

	context.JSON(http.StatusOK, responseUsers)
	logger.ApiInfo(context, "Get all users")
}

// Change the role of a user
//
// @Summary		Change the role of a user as an admin
// @Description	Change the role of a user as an admin
// @Tags			admin
// @Accept			json
// @Produce		json
// @Security		BearerAuth
// @Param			id	path		string	true	"ID of the user"
// @Param			role	body		requests.UserChangeRoleBody	true	"New role of the user"
// @Success		200	{object}	responses.UserRoleReponse
// @Failure		400	{object}	error
// @Failure		401	{object}	error
// @Failure		404	{object}	error
// @Router			/admin/users/{id}/role [patch]
func (handler *UserHandler) UpdateRole(context *gin.Context) {
	userID := context.Param("id")

	var requestBody requests.UserChangeRoleBody
	isBodyValid := utils.Deserialize(&requestBody, context)
	if !isBodyValid {
		return
	}

	user, err := handler.Repository.Get(userID)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	if user.Username == "admin" {
		logger.ApiError(context, "Admin role can't be changed")
		context.AbortWithStatus(http.StatusForbidden)
		return
	}

	if requestBody.Role != "" {
		user.Role = models.UserRole(requestBody.Role)
	}

	updateError := handler.Repository.Update(&user)
	if updateError != nil {
		errorHandlers.HandleGormErrors(updateError, context)
		return
	}

	response := responses.UserRoleReponse{
		ID:                 user.ID,
		Username:           user.Username,
		Role:               user.Role,
		ProfilePicturePath: user.ProfilePicturePath,
	}

	context.JSON(http.StatusOK, response)
	logger.ApiInfo(context, "User "+string(rune(user.ID))+" role updated to "+string(user.Role))

}

// Update the profile picture of a user
//
// @Summary		Update the profile picture of a user
// @Description	Update the profile picture of a user
// @Tags			users
// @Accept			multipart/form-data
// @Produce		json
// @Security		BearerAuth
// @Param			photo	formData	file	true	"Photo file"
// @Success		200	{object}	responses.UserRoleReponse
// @Failure		400	{object}	error
// @Failure		401	{object}	error
// @Router			/users/photo [patch]
func (handler *UserHandler) UpdatePhoto(context *gin.Context) {
	context.Request.Body = http.MaxBytesReader(context.Writer, context.Request.Body, 10<<20)

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
	currentUser, _ := utils.GetCurrentUser(context)

	fileName := currentUser.Username + "-pp"

	filePath, errFilePath := utils.SaveUploadedFile(file, "profile-picture", fileName)
	if errFilePath != nil {
		logger.ApiError(context, "Error saving file: "+filePath)
		context.JSON(http.StatusInternalServerError, gin.H{"error": "Error saving file"})
		return
	}

	utils.DeleteFile("profile-picture", currentUser.ProfilePicturePath)

	currentUser.ProfilePicturePath = filePath

	err := handler.Repository.Update(&currentUser)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	userResponse := responses.UserRoleReponse{
		ID:                 currentUser.ID,
		Username:           currentUser.Username,
		Role:               currentUser.Role,
		ProfilePicturePath: currentUser.ProfilePicturePath,
	}

	context.JSON(200, userResponse)
	logger.ApiInfo(context, "Update the profile picture of user "+currentUser.Username)
}

// Download the profile picture of a user
//
// @Summary		Download the profile picture of a user
// @Description	Download the profile picture of a user
// @Tags			users
// @Accept			json
// @Produce		application/octet-stream
// @Security		BearerAuth
// @Param			userId	path	string	true	"ID of the user"
// @Success      200         {file}    true    "A file stream of the profile picture"
// @Failure		400	{object}	error
// @Failure		401	{object}	error
// @Failure		404	{object}	error
// @Router			/users/photo/{userId} [get]
func (handler *UserHandler) DownloadPhoto(context *gin.Context) {
	userId := context.Param("userId")
	if userId == "" {
		logger.ApiError(context, "User ID missing in the download photo request")
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	user, err := handler.Repository.Get(userId)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	filepath, errFilePath := utils.GetFilePath("profile-picture", user.ProfilePicturePath)
	if errFilePath != nil {
		logger.ApiError(context, "Error getting file path: "+filepath)
		context.JSON(http.StatusInternalServerError, gin.H{"error": "Error getting file path"})
		return
	}
	context.Header("Content-Disposition", "attachment; filename=\""+user.ProfilePicturePath+"\"")
	context.File(filepath)
	logger.ApiInfo(context, "Download the profile picture of user "+user.Username)
}
