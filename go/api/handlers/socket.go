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

func (handler *SocketHandler) HandleConnections(c *gin.Context) {
	ws, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		logger.ApiError(c, "Failed to upgrade to websocket: "+err.Error())
		return
	}
	defer ws.Close()
	clients[ws] = true

	for {
		_, _, err := ws.ReadMessage()
		if err != nil {
			delete(clients, ws)
			break
		}
	}
}

func (handler *SocketHandler) HandleMessages() {
	for {
		msg := <-broadcast
		for client := range clients {
			err := client.WriteJSON(msg)
			if err != nil {
				client.Close()
				delete(clients, client)
			}
		}
	}
}

func BroadcastMessage(msg responses.ChatMessageResponse) {
	fmt.Println("Broadcasting message")
	fmt.Println(msg)
	broadcast <- msg
}
