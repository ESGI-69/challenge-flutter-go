package responses

import "challenge-flutter-go/models"

type UserResponse struct {
	ID                 uint   `json:"id"`
	Username           string `json:"username"`
	ProfilePicturePath string `json:"profilePicturePath"`
	ProfilePictureUri  string `json:"profilePictureUri"`
}

type UserRoleReponse struct {
	ID                 uint            `json:"id"`
	Username           string          `json:"username"`
	Role               models.UserRole `json:"role"`
	ProfilePicturePath string          `json:"profilePicturePath"`
	ProfilePictureUri  string          `json:"profilePictureUri"`
}

type ParticipantTripRole string

const (
	ParticipantTripRoleOwner  ParticipantTripRole = "OWNER"
	ParticipantTripRoleEditor ParticipantTripRole = "EDITOR"
	ParticipantTripRoleViewer ParticipantTripRole = "VIEWER"
	ParticipantTripRoleNone   ParticipantTripRole = "NONE"
)

func StringToParticipantTripRole(role string) ParticipantTripRole {
	switch role {
	case "OWNER":
		return ParticipantTripRoleOwner
	case "EDITOR":
		return ParticipantTripRoleEditor
	case "VIEWER":
		return ParticipantTripRoleViewer
	case "NONE":
		return ParticipantTripRoleNone
	default:
		return ParticipantTripRoleNone
	}
}

type ParticipantResponse struct {
	ID                 uint                `json:"id"`
	Username           string              `json:"username"`
	TripRole           ParticipantTripRole `json:"tripRole"`
	ProfilePicturePath string              `json:"profilePicturePath"`
	ProfilePictureUri  string              `json:"profilePictureUri"`
}
