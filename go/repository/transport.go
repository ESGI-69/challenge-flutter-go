package repository

import (
	"challenge-flutter-go/models"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type TransportRepository struct {
	Database *gorm.DB
}

func (t *TransportRepository) Get(id string) (transport models.Transport, err error) {
	err = t.Database.Preload("Author").First(&transport, id).Error
	return
}

func (t *TransportRepository) GetAllFromTrip(tripId string) (transports []models.Transport, err error) {
	err = t.Database.Where("trip_id = ?", tripId).Preload(clause.Associations).Find(&transports).Error
	return
}

func (t *TransportRepository) Create(transport *models.Transport) error {
	return t.Database.Create(&transport).Preload(clause.Associations).First(&transport).Error
}

// Delete a transport from a trip
func (t *TransportRepository) Delete(id string) error {
	result := t.Database.Delete(&models.Transport{}, id)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}
	return result.Error
}
