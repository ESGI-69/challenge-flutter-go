package utils

import (
	"challenge-flutter-go/api/responses"
	"challenge-flutter-go/models"
)

func UserToParticipantWithRole(Viewers []models.User, Editors []models.User, Owner models.User) (participants []responses.ParticipantResponse) {
	for _, user := range Viewers {
		participants = append(participants, responses.ParticipantResponse{
			ID:       user.ID,
			TripRole: responses.ParticipantTripRoleViewer,
			Username: user.Username,
		})
	}

	for _, user := range Editors {
		participants = append(participants, responses.ParticipantResponse{
			ID:       user.ID,
			TripRole: responses.ParticipantTripRoleEditor,
			Username: user.Username,
		})
	}

	participants = append(participants, responses.ParticipantResponse{
		ID:       Owner.ID,
		TripRole: responses.ParticipantTripRoleOwner,
		Username: Owner.Username,
	})

	return
}
