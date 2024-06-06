package handlers

import (
	"challenge-flutter-go/api/requests"
	"challenge-flutter-go/api/responses"
	"challenge-flutter-go/api/utils"
	"challenge-flutter-go/models"
	"challenge-flutter-go/repository"
	"net/http"

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

	isUserHasViewRights := handler.TripRepository.HasViewRight(trip, currentUser)
	if !isUserHasViewRights {
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
		Author: responses.UserRoleReponse{
			ID:       chatMessageCreated.Author.ID,
			Username: chatMessageCreated.Author.Username,
			Role:     chatMessageCreated.Author.Role,
		},
		Content:   chatMessage.Content,
		CreatedAt: chatMessageCreated.CreatedAt.Format("2006-01-02 15:04:05"),
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

	isUserHasViewRights := handler.TripRepository.HasViewRight(trip, currentUser)
	if !isUserHasViewRights {
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
			Author: responses.UserRoleReponse{
				Username: chatMessage.Author.Username,
				Role:     chatMessage.Author.Role,
			},
			Content:   chatMessage.Content,
			CreatedAt: chatMessage.CreatedAt.Format("2006-01-02 15:04:05"),
		}
	}
	context.JSON(http.StatusOK, chatMessageResponse)
}
