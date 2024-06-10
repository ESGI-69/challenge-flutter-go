package repository

import (
	"challenge-flutter-go/models"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
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
func (n *NoteRepository) Create(note *models.Note) error {
	return n.Database.Create(&note).Preload(clause.Associations).First(&note).Error
}

// Get all the notes of a trip
func (n *NoteRepository) GetNotes(trip models.Trip) (notes []models.Note, err error) {
	err = n.Database.Preload("Author").Model(&models.Note{}).Where("trip_id = ?", trip.ID).Find(&notes).Error
	return
}

// Delete a note from a trip
func (n *NoteRepository) DeleteNote(trip models.Trip, noteID uint) (err error) {
	result := n.Database.Delete(&models.Note{}, noteID)
	return result.Error
}
