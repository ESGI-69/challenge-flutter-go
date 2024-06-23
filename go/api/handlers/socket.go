package handlers

import (
	"challenge-flutter-go/api/responses"
	"challenge-flutter-go/logger"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

var clients = make(map[*websocket.Conn]bool)
var broadcast = make(chan responses.ChatMessageResponse)

type SocketHandler struct{}

// type WebSocketMessage struct {
// 	ID        uint   `json:"id"`
// 	Content   string `json:"content"`
// 	AuthorID  uint   `json:"author_id"`
// 	Author    string `json:"author"`
// 	CreatedAt string `json:"created_at"`
// }

func (handler *SocketHandler) HandleConnections(c *gin.Context) {
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

func (handler *SocketHandler) HandleMessages() {
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
