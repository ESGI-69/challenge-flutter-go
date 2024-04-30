package handlers

import (
	"challenge-flutter-go/api/errorHandlers"
	"challenge-flutter-go/api/utils"
	"challenge-flutter-go/models"
	"challenge-flutter-go/repository"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type UserHandler struct {
	Repository repository.UserRepository
}

func (handler *UserHandler) Get(context *gin.Context) {
	id := context.Param("id")

	if id == "" {
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	uintId, errUintParse := strconv.ParseUint(id, 10, 32)

	if errUintParse != nil {
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	currentUser, exist := context.Get("currentUser")

	if !exist {
		context.AbortWithStatus(http.StatusUnauthorized)
		return
	}

	if currentUser.(models.User).ID != uint(uintId) {
		context.AbortWithStatus(http.StatusUnauthorized)
		return
	}

	user, err := handler.Repository.Get(id)

	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	context.JSON(http.StatusOK, user)
}

func (handler *UserHandler) Create(context *gin.Context) {
	type RequestBody struct {
		Username string `json:"username" binding:"required"`
		Password string `json:"password" binding:"required" validate:"min=8,max=64"`
	}

	var requestBody RequestBody
	isBodyValid := utils.Deserialize(&requestBody, context)
	if !isBodyValid {
		return
	}

	user := models.User{Username: requestBody.Username, Password: requestBody.Password}
	createdUser, userCreationError := handler.Repository.Create(user)
	if userCreationError != nil {
		errorHandlers.HandleGormErrors(userCreationError, context)
	}
	context.JSON(http.StatusCreated, createdUser)
}
