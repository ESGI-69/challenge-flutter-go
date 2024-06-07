package repository

import (
	"challenge-flutter-go/api/responses"
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
	err = t.Database.Preload(clause.Associations).First(&trip, id).Error
	return
}

func (t *TripRepository) GetByInviteCode(invitecode string) (trip models.Trip, err error) {
	err = t.Database.Where("invite_code = ?", invitecode).Preload(clause.Associations).First(&trip).Error
	return trip, err
}

func (t *TripRepository) AddEditor(trip models.Trip, user models.User) {
	t.Database.Model(&trip).Association("Editors").Append(&user)
}

func (t *TripRepository) AddViewer(trip models.Trip, user models.User) {
	t.Database.Model(&trip).Association("Viewers").Append(&user)
}

func (t *TripRepository) RemoveEditor(trip models.Trip, user models.User) {
	t.Database.Model(&trip).Association("Editors").Delete(&user)
}

func (t *TripRepository) RemoveViewer(trip models.Trip, user models.User) {
	t.Database.Model(&trip).Association("Viewers").Delete(&user)
}

// Get all the trips that the user is an editor, a viewer or the owner
func (t *TripRepository) GetAllJoined(user models.User) (trips []models.Trip, err error) {
	err = t.Database.Preload("Owner").
		Preload(clause.Associations).
		Joins("LEFT JOIN trip_viewers ON trip_viewers.trip_id = trips.id").
		Joins("LEFT JOIN trip_editors ON trip_editors.trip_id = trips.id").
		Where("trips.owner_id = ? OR trip_viewers.user_id = ? OR trip_editors.user_id = ?", user.ID, user.ID, user.ID).
		Find(&trips).Error
	return
}

// If the user is the owner or an editor of the trip
//
// If the user is not in the editors list, it will return false
func (t *TripRepository) HasEditRight(trip models.Trip, user models.User) (isEditor bool) {
	isOwner := trip.OwnerID == user.ID
	isEditor = false
	err := t.Database.Preload("Editors").First(&trip, "id = ?", trip.ID).Error
	if err == nil {
		for _, editor := range trip.Editors {
			if editor.ID == user.ID {
				isEditor = true
			}
		}
	}
	return isOwner || isEditor
}

// If the user is a viewer of the trip
//
// If the user is not in the viewers list, it will return false
func (t *TripRepository) HasViewRight(trip models.Trip, user models.User) (isViewer bool) {
	isViewer = false
	err := t.Database.Preload("Viewers").First(&trip, "id = ?", trip.ID).Error
	if err == nil {
		for _, viewer := range trip.Viewers {
			if viewer.ID == user.ID {
				isViewer = true
			}
		}
	}
	return isViewer || t.HasEditRight(trip, user)
}

func (t *TripRepository) GetUserTripRole(trip models.Trip, user models.User) (role responses.ParticipantTripRole) {
	if trip.OwnerID == user.ID {
		return responses.ParticipantTripRoleOwner
	}
	if t.HasEditRight(trip, user) {
		return responses.ParticipantTripRoleEditor
	}
	if t.HasViewRight(trip, user) {
		return responses.ParticipantTripRoleViewer
	}
	return responses.ParticipantTripRoleNone
}

// Get all the users who has access to the trip
func (t *TripRepository) GetParticipants(trip models.Trip) (participants []models.User, err error) {
	var participantsBuffer []models.User
	var associatedTrip = t.Database.Model(&trip).Association(clause.Associations)
	associatedTrip.Find(&participantsBuffer, "Editors")
	participants = append(participants, participantsBuffer...)
	participantsBuffer = []models.User{}
	associatedTrip.Find(&participantsBuffer, "Viewers")
	participants = append(participants, participantsBuffer...)
	participantsBuffer = []models.User{}
	// Retrieve the owner
	associatedTrip.Find(&participantsBuffer, "Owner")
	participants = append(participants, participantsBuffer...)
	return
}

// Update a trip
func (t *TripRepository) Update(trip models.Trip) (updatedTrip models.Trip, err error) {
	err = t.Database.Save(&trip).Error
	return trip, err
}
