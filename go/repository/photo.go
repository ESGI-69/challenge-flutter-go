package repository

import (
	"challenge-flutter-go/models"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type PhotoRepository struct {
	Database *gorm.DB
}

// Get a photo by its ID
func (d *PhotoRepository) Get(id string) (photo models.Photo, err error) {
	err = d.Database.Preload(clause.Associations).First(&photo, id).Error
	return
}

// Create a photo & associate it with a trip
func (d *PhotoRepository) Create(photo *models.Photo) error {
	return d.Database.Create(&photo).Preload(clause.Associations).First(&photo).Error
}

// Get all the photos of a trip
func (d *PhotoRepository) GetPhotos(tripId string) (photos []models.Photo, err error) {
	err = d.Database.Model(&models.Photo{}).Preload(clause.Associations).Where("trip_id = ?", tripId).Find(&photos).Error
	return
}

// Delete a photo from a trip
func (d *PhotoRepository) DeletePhoto(id string) (err error) {
	var photo models.Photo
	// il faut load les details de la photo pour le hook, sinon le dans le hook le photo est empty
	if err = d.Database.Where("id = ?", id).First(&photo).Error; err != nil {
		return err
	}
	result := d.Database.Delete(&photo)
	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}
	return result.Error
}
