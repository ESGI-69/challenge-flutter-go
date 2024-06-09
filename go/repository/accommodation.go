package repository

import (
	"challenge-flutter-go/models"

	"gorm.io/gorm"
)

type AccommodationRepository struct {
	Database *gorm.DB
}

func (t *AccommodationRepository) Create(accommodation *models.Accommodation) error {
	return t.Database.Create(&accommodation).Error
}

func (t *AccommodationRepository) Delete(id string) error {
	result := t.Database.Delete(&models.Accommodation{}, id)
	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}
	return result.Error
}
