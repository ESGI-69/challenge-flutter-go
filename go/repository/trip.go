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
	err = t.Database.Preload(clause.Associations).Preload("Transports."+clause.Associations).First(&trip, id).Error
	return
}

func (t *TripRepository) GetByInviteCode(invitecode string) (trip models.Trip, err error) {
	err = t.Database.Where("invite_code = ?", invitecode).Preload(clause.Associations).First(&trip).Error
	return trip, err
}

func (t *TripRepository) AddEditor(trip *models.Trip, user models.User) {
	t.Database.Model(&trip).Association("Editors").Append(&user)
}

func (t *TripRepository) AddViewer(trip *models.Trip, user models.User) {
	t.Database.Model(&trip).Association("Viewers").Append(&user)
}

func (t *TripRepository) RemoveEditor(trip *models.Trip, user models.User) {
	t.Database.Model(&trip).Association("Editors").Delete(&user)
}

func (t *TripRepository) RemoveViewer(trip *models.Trip, user models.User) {
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
func (t *TripRepository) Update(trip *models.Trip) (err error) {
	return t.Database.Save(&trip).Preload(clause.Associations).Error
}
