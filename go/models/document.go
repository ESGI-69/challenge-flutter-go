package models

import (
	"gorm.io/gorm"
)

type Document struct {
	gorm.Model
	Title       string `gorm:"not null"`
	Description string `gorm:"not null"`
	Path        string `gorm:"not null"`
	TripID      uint
	Trip        Trip `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}
