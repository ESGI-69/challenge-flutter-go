package repository

import (
	"challenge-flutter-go/models"

	"gorm.io/gorm"
)

type TripRepository struct {
	Database *gorm.DB
}

// Create a trip.
//
// The owner of the trip will be added as an editor in participants
func (t *TripRepository) Create(trip models.Trip) (createdTrip models.Trip, err error) {
	result := t.Database.Create(&trip)
	t.AddParticipant(trip, trip.Owner, models.TripParticipantRoleEditor)
	return trip, result.Error
}

func (t *TripRepository) Get(id string) (trip models.Trip, err error) {
	err = t.Database.Preload("Participants").First(&trip, id).Error
	return
}

// Add a participant to a trip with the given role
func (t *TripRepository) AddParticipant(trip models.Trip, user models.User, role models.TripParticipantRole) (err error) {
	//Petit hack pour éviter de rajouter un participant déjà existant
	var count int64
	t.Database.Model(&models.TripParticipant{}).Where("trip_id = ? AND user_id = ?", trip.ID, user.ID).Count(&count)
	if count > 0 {
		return nil
	}

	participant := models.TripParticipant{
		TripID: trip.ID,
		UserID: user.ID,
		Role:   role,
	}

	result := t.Database.Create(&participant)
	return result.Error
}
