package utils

import (
	"challenge-flutter-go/api/responses"
	"challenge-flutter-go/models"
	"strconv"
)

func UserToParticipantWithRole(Viewers []models.User, Editors []models.User, Owner models.User) (participants []responses.ParticipantResponse) {
	for _, user := range Viewers {
		participants = append(participants, responses.ParticipantResponse{
			ID:                 user.ID,
			TripRole:           responses.ParticipantTripRoleViewer,
			Username:           user.Username,
			ProfilePicturePath: user.ProfilePicturePath,
			ProfilePictureUri:  "/users/photo/" + strconv.FormatUint(uint64(user.ID), 10),
		})
	}

	for _, user := range Editors {
		participants = append(participants, responses.ParticipantResponse{
			ID:                 user.ID,
			TripRole:           responses.ParticipantTripRoleEditor,
			Username:           user.Username,
			ProfilePicturePath: user.ProfilePicturePath,
			ProfilePictureUri:  "/users/photo/" + strconv.FormatUint(uint64(user.ID), 10),
		})
	}

	participants = append(participants, responses.ParticipantResponse{
		ID:                 Owner.ID,
		TripRole:           responses.ParticipantTripRoleOwner,
		Username:           Owner.Username,
		ProfilePicturePath: Owner.ProfilePicturePath,
		ProfilePictureUri:  "/users/photo/" + strconv.FormatUint(uint64(Owner.ID), 10),
	})

	return
}
