package repository

import (
	"challenge-flutter-go/models"

	"gorm.io/gorm"
)

type TransportRepository struct {
	Database *gorm.DB
}

func (t *TransportRepository) Create(transport *models.Transport) error {
	return t.Database.Create(&transport).Error
}

// Delete a transport from a trip
func (t *TransportRepository) Delete(id string) error {
	result := t.Database.Delete(&models.Transport{}, id)
	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}
	return result.Error
}
