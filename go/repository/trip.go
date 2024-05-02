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

// Add a participant to a trip with the given role
func (t *TripRepository) AddParticipant(trip models.Trip, user models.User, role models.TripParticipantRole) (err error) {
	participant := models.TripParticipant{
		TripID: trip.ID,
		UserID: user.ID,
		Role:   role,
	}

	result := t.Database.Create(&participant)
	return result.Error
}
