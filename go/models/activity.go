package models

import "gorm.io/gorm"

type Activity struct {
	gorm.Model
	Name        string `gorm:"not null"`
	Description string
	TripID      uint
	Trip        Trip `gorm:"constraint:OnUpdate:CASCADE;"`
	OwnerID     uint
	Owner       User    `gorm:"constraint:OnUpdate:CASCADE;"`
	Price       float64 `gorm:"not null" validate:"min=0"`
	Location    string
	Latitude    float64
	Longitude   float64
}
