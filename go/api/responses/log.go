package responses

import "challenge-flutter-go/models"

type LogResponse struct {
	ID        uint            `json:"id"`
	Level     models.LogLevel `json:"level"`
	Message   string          `json:"message"`
	Timestamp string          `json:"timestamp"`
	Ip        string          `json:"ip"`
	Path      string          `json:"path"`
	Method    string          `json:"method"`
	Username  string          `json:"username"`
}
