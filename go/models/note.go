package models

import (
	"time"

	"gorm.io/gorm"
)

type Note struct {
	gorm.Model
	Title     string `gorm:"not null"`
	Content   string `gorm:"not null"`
	TripID    uint
	Trip      Trip      `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	CreatedAt time.Time `gorm:"not null"`
	UpdatedAt time.Time `gorm:"not null"`
	AuthorId  uint
	Author    User `gorm:"constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
}
