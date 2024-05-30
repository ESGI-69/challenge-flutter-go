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

// Get all the transports of a trip
func (t *TransportRepository) GetTransports(trip models.Trip) (transports []models.Transport, err error) {
	err = t.Database.Model(&models.Transport{}).Where("trip_id = ?", trip.ID).Find(&transports).Error
	return
}

// Delete a transport from a trip
func (t *TransportRepository) DeleteTransport(trip models.Trip, transportID uint) (err error) {
	result := t.Database.Delete(&models.Transport{}, transportID)
	return result.Error
}
