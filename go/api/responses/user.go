package responses

import "challenge-flutter-go/models"

type UserResponse struct {
	ID       uint   `json:"id"`
	Username string `json:"username"`
	Role     string `json:"role"`
}

type UserInfoResponse struct {
	ID       uint          `json:"id"`
	Username string        `json:"username"`
	Role     string        `json:"role"`
	Trips    []models.Trip `json:"trips"`
}
