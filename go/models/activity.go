package models

import (
	"challenge-flutter-go/api/utils/geo"
	"errors"
	"time"

	"gorm.io/gorm"
)

type Activity struct {
	gorm.Model
	Name        string `gorm:"not null"`
	Description string
	TripID      uint
	Trip        Trip `gorm:"constraint:OnUpdate:CASCADE;"`
	OwnerID     uint
	Owner       User      `gorm:"constraint:OnUpdate:CASCADE;"`
	Price       float64   `gorm:"not null" validate:"min=0"`
	StartDate   time.Time `gorm:"not null"`
	EndDate     time.Time `gorm:"not null"`
	Location    string
	Latitude    float64 `gorm:"default:0"`
	Longitude   float64 `gorm:"default:0"`
}

func (a *Activity) BeforeSave(tx *gorm.DB) (err error) {
	if err = geo.GetGeoLocation(a.Location, &a.Latitude, &a.Longitude); err != nil {
		return errors.New("geo location api is on an error state")
	}
	return
}
