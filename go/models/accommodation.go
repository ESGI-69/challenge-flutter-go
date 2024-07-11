package models

import (
	"challenge-flutter-go/api/utils/geo"
	"errors"
	"time"

	"gorm.io/gorm"
)

type AccommodationType string

const (
	AccommodationTypeHotel  AccommodationType = "hotel"
	AccommodationTypeAirbnb AccommodationType = "airbnb"
	AccommodationTypeOther  AccommodationType = "other"
)

type Accommodation struct {
	gorm.Model
	AccommodationType AccommodationType `gorm:"not null; default:'hotel'"`
	StartDate         time.Time         `gorm:"not null"`
	TripID            uint
	Trip              Trip      `gorm:"constraint:OnUpdate:CASCADE"`
	EndDate           time.Time `gorm:"not null"`
	Address           string    `gorm:"not null"`
	BookingURL        string    `gorm:"null"`
	Name              string    `gorm:"not null"`
	Latitude          float64   `gorm:"default:0"`
	Longitude         float64   `gorm:"default:0"`
	Price             float64   `gorm:"not null; default:0" validate:"min=0"`
}

func (a *Accommodation) isAccommodationTypeValid() (isValid bool) {
	return a.AccommodationType == AccommodationTypeHotel || a.AccommodationType == AccommodationTypeAirbnb || a.AccommodationType == AccommodationTypeOther
}

func (a *Accommodation) BeforeSave(tx *gorm.DB) (err error) {
	if !a.isAccommodationTypeValid() {
		return gorm.ErrInvalidData
	}
	if err = geo.GetGeoLocation(a.Address, &a.Latitude, &a.Longitude); err != nil {
		return errors.New("geo location api is on an error state")
	}
	return
}
