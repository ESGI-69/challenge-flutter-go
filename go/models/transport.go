package models

import (
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
	TransportType  TransportType `gorm:"not null; default:'car'"`
	StartDate      time.Time     `gorm:"not null"`
	TripID         uint
	Trip           Trip      `gorm:"constraint:OnUpdate:CASCADE"`
	EndDate        time.Time `gorm:"not null"`
	StartAddress   string    `gorm:"not null"`
	EndAddress     string    `gorm:"not null"`
	MeetingAddress string
	MeetingTime    time.Time
}
