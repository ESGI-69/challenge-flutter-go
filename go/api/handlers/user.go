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
		ID:       user.ID,
		Username: user.Username,
		Role:     user.Role,
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

	reponse := responses.UserRoleReponse{
		ID:       user.ID,
		Username: user.Username,
		Role:     user.Role,
	}
	context.JSON(http.StatusCreated, reponse)
	logger.ApiInfo(context, "User "+string(rune(user.ID))+" created")
}
