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

var clients = make(map[*websocket.Conn]string)
var rooms = make(map[string]map[*websocket.Conn]bool)
var broadcast = make(chan broadcastMessage)

type broadcastMessage struct {
	Room    string
	Message responses.ChatMessageResponse
}

type SocketHandler struct{}

func (handler *SocketHandler) HandleConnections(c *gin.Context) {
	ws, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		logger.ApiError(c, "Failed to upgrade to websocket: "+err.Error())
		return
	}
	defer ws.Close()

	roomId := c.Query("roomId")
	if roomId == "" {
		logger.ApiError(c, "RoomId query parameter is required")
		return
	}

	if rooms[roomId] == nil {
		rooms[roomId] = make(map[*websocket.Conn]bool)
	}
	rooms[roomId][ws] = true
	clients[ws] = roomId

	for {
		_, _, err := ws.ReadMessage()
		if err != nil {
			delete(rooms[roomId], ws)
			delete(clients, ws)
			break
		}
	}
}

func (handler *SocketHandler) HandleMessages() {
	for {
		msg := <-broadcast
		room := msg.Room
		for client := range rooms[room] {
			err := client.WriteJSON(msg.Message)
			if err != nil {
				client.Close()
				delete(rooms[room], client)
			}
		}
	}
}

func BroadcastMessage(msg responses.ChatMessageResponse, roomId string) {
	fmt.Println("Broadcasting message to room:", roomId)
	fmt.Println(msg)
	broadcast <- broadcastMessage{Room: roomId, Message: msg}
}
