package repository

import (
	"challenge-flutter-go/models"

	"gorm.io/gorm"
)

type NoteRepository struct {
	Database *gorm.DB
}

// Get a note by its ID
func (n *NoteRepository) Get(id string) (note models.Note, err error) {
	err = n.Database.Preload("Author").First(&note, id).Error
	return
}

// Create a note & associate it with a trip
func (n *NoteRepository) AddNote(trip models.Trip, note models.Note) (models.Note, error) {
	note.TripID = trip.ID

	result := n.Database.Create(&note)
	if result.Error != nil {
		return models.Note{}, result.Error
	}
	//add associations
	n.Database.Model(&note).Association("Trip").Append(&trip)
	return note, nil
}

// Get all the notes of a trip
func (n *NoteRepository) GetNotes(trip models.Trip) (notes []models.Note, err error) {
	err = n.Database.Model(&models.Note{}).Where("trip_id = ?", trip.ID).Find(&notes).Error
	return
}

// Delete a note from a trip
func (n *NoteRepository) DeleteNote(trip models.Trip, noteID uint) (err error) {
	result := n.Database.Delete(&models.Note{}, noteID)
	return result.Error
}

// If the user is not the author of the note, it will return false
func (n *NoteRepository) IsAuthor(note models.Note, user models.User) bool {
	return note.AuthorId == user.ID
}
