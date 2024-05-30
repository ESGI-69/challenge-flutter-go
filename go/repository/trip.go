package repository

import (
	"challenge-flutter-go/models"
	"crypto/rand"
	"encoding/base64"
	"strconv"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
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

	// Generate a random string for the invite code
	randomBytes := make([]byte, 8)
	_, err = rand.Read(randomBytes)
	if err != nil {
		return trip, err
	}
	randomString := base64.URLEncoding.EncodeToString(randomBytes)[:8]
	trip.InviteCode = strconv.Itoa(int(trip.ID)) + randomString
	t.Database.Save(&trip)

	return trip, result.Error
}

func (t *TripRepository) Get(id string) (trip models.Trip, err error) {
	err = t.Database.Preload(clause.Associations).Preload("Participants").First(&trip, id).Error
	return
}

func (t *TripRepository) GetByInviteCode(invitecode string) (trip models.Trip, err error) {
	err = t.Database.Where("invite_code = ?", invitecode).Preload("Participants").First(&trip).Error
	return trip, err
}

// Add a participant to a trip with	 the given role
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

// Get all the participants of a trip with their role
func (t *TripRepository) GetParticipants(trip models.Trip) (participants []models.TripParticipant, err error) {
	err = t.Database.Model(&models.TripParticipant{}).Where("trip_id = ?", trip.ID).Find(&participants).Error
	return
}

func (t *TripRepository) GetAllJoined(user models.User) (trips []models.Trip, err error) {
	err = t.Database.Model(&user).Where("owner_id = ?", user.ID).Preload("Owner").Association("Trips").Find(&trips)
	return
}
