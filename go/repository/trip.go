package repository

import (
	"challenge-flutter-go/models"

	"gorm.io/gorm"
)

type TripRepository struct {
	Database *gorm.DB
}

func (t *TripRepository) Create(trip models.Trip) (createdTrip models.Trip, err error) {
	result := t.Database.Create(&trip)
	return trip, result.Error
}
