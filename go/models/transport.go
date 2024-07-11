package models

import (
	"challenge-flutter-go/api/utils/geo"
	"errors"
	"time"

	"gorm.io/gorm"
)

type TransportType string

const (
	TransportTypeCar   TransportType = "car"
	TransportTypePlane TransportType = "plane"
	TransportTypeBus   TransportType = "bus"
)

type Transport struct {
	gorm.Model
	TransportType    TransportType `gorm:"not null; default:'car'"`
	StartDate        time.Time     `gorm:"not null"`
	TripID           uint
	Trip             Trip `gorm:"constraint:OnUpdate:CASCADE;not null"`
	AuthorID         uint
	Author           User      `gorm:"constraint:OnUpdate:CASCADE;not null"`
	EndDate          time.Time `gorm:"not null"`
	StartAddress     string    `gorm:"not null"`
	StartLatitude    float64   `gorm:"default:0"`
	StartLongitude   float64   `gorm:"default:0"`
	EndAddress       string    `gorm:"not null"`
	EndLatitude      float64   `gorm:"default:0"`
	EndLongitude     float64   `gorm:"default:0"`
	MeetingAddress   string
	MeetingLatitude  float64 `gorm:"default:0"`
	MeetingLongitude float64 `gorm:"default:0"`
	MeetingTime      time.Time
	Price            float64 `gorm:"not null; default:0" validate:"min=0"`
}

// Checks if the transport type is valid, returns false if it's not & aborts the request
func (transport *Transport) isTransportTypeValid() (isValid bool) {
	return transport.TransportType == TransportTypeCar || transport.TransportType == TransportTypePlane || transport.TransportType == TransportTypeBus
}

func (transport *Transport) BeforeSave(tx *gorm.DB) (err error) {
	if !transport.isTransportTypeValid() {
		return gorm.ErrInvalidData
	}
	if err = geo.GetGeoLocation(transport.StartAddress, &transport.StartLatitude, &transport.StartLongitude); err != nil {
		return errors.New("geo location api is on an error state")
	}
	if err = geo.GetGeoLocation(transport.EndAddress, &transport.EndLatitude, &transport.EndLongitude); err != nil {
		return errors.New("geo location api is on an error state")
	}
	if transport.MeetingAddress != "" {
		if err = geo.GetGeoLocation(transport.MeetingAddress, &transport.MeetingLatitude, &transport.MeetingLongitude); err != nil {
			return errors.New("geo location api is on an error state")
		}
	}
	return
}
