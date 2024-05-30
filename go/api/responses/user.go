package responses

import "challenge-flutter-go/models"

type UserResponse struct {
	ID       uint   `json:"id"`
	Username string `json:"username"`
}

type UserRoleReponse struct {
	ID       uint            `json:"id"`
	Username string          `json:"username"`
	Role     models.UserRole `json:"role"`
}

type ParticipantTripRole string

const (
	ParticipantTripRoleOwner  ParticipantTripRole = "OWNER"
	ParticipantTripRoleEditor ParticipantTripRole = "EDITOR"
	ParticipantTripRoleViewer ParticipantTripRole = "VIEWER"
)

type ParticipantResponse struct {
	ID       uint                `json:"id"`
	Username string              `json:"user"`
	TripRole ParticipantTripRole `json:"tripRole"`
}
