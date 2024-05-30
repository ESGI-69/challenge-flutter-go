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
	err = t.Database.Where("invite_code = ?", invitecode).Preload("Participants").First(&trip).Error
	return trip, err
}

func (t *TripRepository) AddEditor(trip models.Trip, user models.User) {
	t.Database.Model(&trip).Association("Editors").Append(&user)
}

// Get all the trips that the user is an editor, a viewer or the owner
func (t *TripRepository) GetAllJoined(user models.User) (trips []models.Trip, err error) {
	err = t.Database.Model(&models.Trip{}).Preload(clause.Associations).Where("owner_id = ? OR id IN (SELECT trip_id FROM trip_editors WHERE user_id = ?) OR id IN (SELECT trip_id FROM trip_viewers WHERE user_id = ?)", user.ID, user.ID, user.ID).Find(&trips).Error
	return
}

func (t *TripRepository) HasEditRight(trip models.Trip, user models.User) (isEditor bool) {
	editorError := t.Database.Model(&trip).Association("Editors").Find(&user)
	return editorError == nil || trip.OwnerID == user.ID
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
