package repository

import (
	"challenge-flutter-go/models"

	"gorm.io/gorm"
)

type TransportRepository struct {
	Database *gorm.DB
}

// Create a transport & associate it with a trip
func (t *TransportRepository) AddTransport(trip models.Trip, transport models.Transport) (models.Transport, error) {
	transport.TripID = trip.ID

	result := t.Database.Create(&transport)
	if result.Error != nil {
		return models.Transport{}, result.Error
	}
	//add associations
	t.Database.Model(&transport).Association("Trip").Append(&trip)
	return transport, nil
}

// Delete a transport from a trip
func (t *TransportRepository) DeleteTransport(trip models.Trip, transportID uint) (err error) {
	result := t.Database.Delete(&models.Transport{}, transportID)
	return result.Error
}

// Retrive all transports from a trip
