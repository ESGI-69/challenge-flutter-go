package handlers

import (
	"challenge-flutter-go/api/errorHandlers"
	"challenge-flutter-go/api/requests"
	"challenge-flutter-go/api/responses"
	"challenge-flutter-go/api/utils"
	"challenge-flutter-go/logger"
	"challenge-flutter-go/models"
	"challenge-flutter-go/repository"
	"fmt"
	"net/http"
	"time"

	"github.com/gorilla/websocket"

	"github.com/gin-gonic/gin"
)

type ChatMessageHandler struct {
	Repository     repository.ChatMessageRepository
	TripRepository repository.TripRepository
}

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

var clients = make(map[*websocket.Conn]bool)
var broadcast = make(chan responses.ChatMessageResponse)

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
	tripId := context.Param("id")

	var requestBody requests.ChatMessageCreateBody
	isBodyValid := utils.Deserialize(&requestBody, context)
	if !isBodyValid {
		return
	}

	currentUser, _ := utils.GetCurrentUser(context)

	trip, _ := handler.TripRepository.Get(tripId)

	chatMessage := models.ChatMessage{
		Content: requestBody.Content,
		Author:  currentUser,
		Trip:    trip,
	}

	errChatMessage := handler.Repository.Create(&chatMessage)
	if errChatMessage != nil {
		errorHandlers.HandleGormErrors(errChatMessage, context)
		return
	}

	response := responses.ChatMessageResponse{
		ID: chatMessage.ID,
		Author: responses.UserResponse{
			ID:       chatMessage.Author.ID,
			Username: chatMessage.Author.Username,
		},
		Content:   chatMessage.Content,
		CreatedAt: chatMessage.CreatedAt.Format(time.RFC3339),
	}

	context.JSON(http.StatusCreated, response)
	logger.ApiInfo(context, "Chat message "+chatMessage.Content+" added to trip "+tripId)
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
	tripId := context.Param("id")

	trip, _ := handler.TripRepository.Get(tripId)

	chatMessages, errChatMessages := handler.Repository.GetAllFromTrip(trip)
	if errChatMessages != nil {
		errorHandlers.HandleGormErrors(errChatMessages, context)
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
	logger.ApiInfo(context, "Get all chat messages from trip "+tripId)
}

// Handle WebSocket connections
func (handler *ChatMessageHandler) HandleConnections(c *gin.Context) {
	ws, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		logger.ApiError(c, "Failed to upgrade to websocket: "+err.Error())
		return
	}
	defer ws.Close()
	clients[ws] = true

	for {
		var msg responses.ChatMessageResponse
		err := ws.ReadJSON(&msg)
		if err != nil {
			delete(clients, ws)
			break
		}
		broadcast <- msg
	}
}

func (handler *ChatMessageHandler) HandleMessages() {
	fmt.Println("Handle messages")
	for {
		msg := <-broadcast
		fmt.Println("Received message :", msg)
		fmt.Println("Broadcasting message")
		for client := range clients {
			fmt.Println("Sending message to client")
			err := client.WriteJSON(msg)
			if err != nil {
				client.Close()
				delete(clients, client)
			}
		}
	}
}
