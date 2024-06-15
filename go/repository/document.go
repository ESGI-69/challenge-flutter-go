package repository

import (
	"challenge-flutter-go/models"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type DocumentRepository struct {
	Database *gorm.DB
}

// Get a document by its ID
func (d *DocumentRepository) Get(id string) (document models.Document, err error) {
	err = d.Database.First(&document, id).Error
	return
}

// Create a document & associate it with a trip
func (d *DocumentRepository) Create(document *models.Document) error {
	return d.Database.Create(&document).Preload(clause.Associations).First(&document).Error
}

// Get all the documents of a trip
func (d *DocumentRepository) GetDocuments(trip models.Trip) (documents []models.Document, err error) {
	err = d.Database.Model(&models.Document{}).Where("trip_id = ?", trip.ID).Find(&documents).Error
	return
}

// Delete a document from a trip
func (d *DocumentRepository) DeleteDocument(trip models.Trip, documentID uint) (err error) {
	var document models.Document
	// il faut load les details du doc pour le hook, sinon le dans le hook le document est empty
	if err = d.Database.Where("id = ?", documentID).First(&document).Error; err != nil {
		return err
	}
	return d.Database.Delete(&document).Error
}
