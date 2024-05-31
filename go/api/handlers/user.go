package handlers

import (
	"challenge-flutter-go/api/errorHandlers"
	"challenge-flutter-go/api/requests"
	"challenge-flutter-go/api/responses"
	"challenge-flutter-go/api/utils"
	"challenge-flutter-go/models"
	"challenge-flutter-go/repository"
	"log"
	"net/http"
	"strconv"
	"time"

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
//	@Success		200	{object}	responses.UserInfoResponse
//	@Failure		400	{object}	error
//	@Failure		401	{object}	error
//	@Failure		404	{object}	error
//	@Router			/users/{id} [get]
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

	currentUser, exist := utils.GetCurrentUser(context)
	if !exist {
		return
	}

	if currentUser.ID != uint(uintId) {
		log.Println("User is not authorized to access this resource")
		context.AbortWithStatus(http.StatusUnauthorized)
		return
	}

	user, err := handler.Repository.Get(id)

	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	userTrips := []responses.TripResponse{}
	for _, trip := range user.Trips {
		userTrips = append(userTrips, responses.TripResponse{
			ID:        trip.ID,
			Name:      trip.Name,
			StartDate: trip.StartDate.Format(time.RFC3339),
			EndDate:   trip.EndDate.Format(time.RFC3339),
			Country:   trip.Country,
			City:      trip.City,
			Owner: responses.UserResponse{
				ID:       trip.Owner.ID,
				Username: trip.Owner.Username,
				Role:     string(trip.Owner.Role),
			},
			Participants: []responses.UserResponse{},
		})
	}

	response := responses.UserInfoResponse{
		ID:       user.ID,
		Username: user.Username,
		Trips:    userTrips,
	}

	context.JSON(http.StatusOK, response)
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
//	@Success		201		{object}	responses.UserInfoResponse
//	@Failure		400		{object}	error
//	@Router			/users [post]
func (handler *UserHandler) Create(context *gin.Context) {

	var requestBody requests.UserCreateBody
	isBodyValid := utils.Deserialize(&requestBody, context)
	if !isBodyValid {
		return
	}

	user := models.User{Username: requestBody.Username, Password: requestBody.Password}
	createdUser, userCreationError := handler.Repository.Create(user)
	if userCreationError != nil {
		errorHandlers.HandleGormErrors(userCreationError, context)
		return
	}

	userTrips := []responses.TripResponse{}
	for _, trip := range createdUser.Trips {
		userTrips = append(userTrips, responses.TripResponse{
			ID:        trip.ID,
			Name:      trip.Name,
			StartDate: trip.StartDate.Format(time.RFC3339),
			EndDate:   trip.EndDate.Format(time.RFC3339),
			Country:   trip.Country,
			City:      trip.City,
			Owner: responses.UserResponse{
				ID:       trip.Owner.ID,
				Username: trip.Owner.Username,
				Role:     string(trip.Owner.Role),
			},
			Participants: []responses.UserResponse{},
		})
	}

	reponse := responses.UserInfoResponse{
		ID:       createdUser.ID,
		Username: createdUser.Username,
		Role:     string(createdUser.Role),
		Trips:    userTrips,
	}
	context.JSON(http.StatusCreated, reponse)
}
