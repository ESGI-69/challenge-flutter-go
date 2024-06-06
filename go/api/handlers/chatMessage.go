package handlers

import (
	"challenge-flutter-go/api/requests"
	"challenge-flutter-go/api/responses"
	"challenge-flutter-go/api/utils"
	"challenge-flutter-go/models"
	"challenge-flutter-go/repository"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

type ChatMessageHandler struct {
	Repository     repository.ChatMessageRepository
	TripRepository repository.TripRepository
}

// @Summary		Create a new chat message on trip
// @Description	Create a new chat message & associate it with the trip
// @Tags			chatMessage
// @Accept			json
// @Produce		json
// @Security		BearerAuth
// @Param			id		path		string	true	"ID of the trip"
// @Param			body	body		requests.ChatMessageCreateBody	true	"Body of the chat message"
// @Success		201		{object}	responses.ChatMessageResponse
// @Failure		400		{object}	error
// @Failure		401		{object}	error
// @Router			/trips/{id}/chatMessages [post]
func (handler *ChatMessageHandler) AddChatMessageToTrip(context *gin.Context) {
	id := context.Param("id")
	if id == "" {
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	var requestBody requests.ChatMessageCreateBody
	isBodyValid := utils.Deserialize(&requestBody, context)
	if !isBodyValid {
		return
	}

	currentUser, exist := utils.GetCurrentUser(context)
	if !exist {
		return
	}

	trip, errTrip := handler.TripRepository.Get(id)
	if errTrip != nil {
		context.AbortWithStatus(http.StatusNotFound)
		return
	}

	isUserHasEditRights := handler.TripRepository.HasEditRight(trip, currentUser)
	if !isUserHasEditRights {
		if trip.OwnerID != currentUser.ID {
			context.AbortWithStatus(http.StatusUnauthorized)
			return
		}
	}

	var chatMessage = models.ChatMessage{
		Content: requestBody.Content,
		Author:  currentUser,
	}

	var chatMessageCreated, errChatMessage = handler.Repository.AddChatMessage(trip, chatMessage)
	if errChatMessage != nil {
		context.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	response := responses.ChatMessageResponse{
		ID: chatMessageCreated.ID,
		Author: responses.UserResponse{
			ID:       chatMessageCreated.Author.ID,
			Username: chatMessageCreated.Author.Username,
		},
		Content:   chatMessage.Content,
		CreatedAt: chatMessageCreated.CreatedAt.Format(time.RFC3339),
	}

	context.JSON(http.StatusCreated, response)
}

// @Summary		Get all chat messages of trip
// @Description	Get all chat messages of the trip
// @Tags			chatMessage
// @Accept			json
// @Produce		json
// @Security		BearerAuth
// @Param			id		path		string	true	"ID of the trip"
// @Success		200		{object}	[]responses.ChatMessageResponse
// @Failure		400		{object}	error
// @Failure		401		{object}	error
// @Failure		404		{object}	error
// @Router			/trips/{id}/chatMessages [get]
func (handler *ChatMessageHandler) GetChatMessagesOfTrip(context *gin.Context) {
	id := context.Param("id")
	if id == "" {
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	trip, errTrip := handler.TripRepository.Get(id)
	if errTrip != nil {
		context.AbortWithStatus(http.StatusNotFound)
		return
	}

	currentUser, exist := utils.GetCurrentUser(context)
	if !exist {
		return
	}

	isUserHasEditRights := handler.TripRepository.HasEditRight(trip, currentUser)
	if !isUserHasEditRights {
		if trip.OwnerID != currentUser.ID {
			context.AbortWithStatus(http.StatusUnauthorized)
			return
		}
	}

	chatMessages, errChatMessages := handler.Repository.GetChatMessages(trip)
	if errChatMessages != nil {
		context.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	chatMessageResponse := make([]responses.ChatMessageResponse, len(chatMessages))
	for i, chatMessage := range chatMessages {
		chatMessageResponse[i] = responses.ChatMessageResponse{
			ID: chatMessage.ID,
			Author: responses.UserResponse{
				ID:       chatMessage.Author.ID,
				Username: chatMessage.Author.Username,
			},
			Content:   chatMessage.Content,
			CreatedAt: chatMessage.CreatedAt.Format(time.RFC3339),
		}
	}
	context.JSON(http.StatusOK, chatMessageResponse)
}
