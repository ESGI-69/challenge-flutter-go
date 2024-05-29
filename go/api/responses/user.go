package responses

import "challenge-flutter-go/models"

type UserResponse struct {
	ID       uint          `json:"id"`
	Username string        `json:"username"`
	Trips    []models.Trip `json:"trips"`
}
