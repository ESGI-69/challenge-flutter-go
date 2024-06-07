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
func (t *TransportRepository) DeleteTransport(trip models.Trip, transportID uint) (err error) {
	result := t.Database.Delete(&models.Transport{}, transportID)
	return result.Error
}

// Retrive all transports from a trip
