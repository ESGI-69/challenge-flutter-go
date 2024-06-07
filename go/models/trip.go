package models

import (
	"time"

	"gorm.io/gorm"
)

type Trip struct {
	gorm.Model
	Name        string `gorm:"not null"`
	Description string
	OwnerID     uint
	Owner       User        `gorm:"constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
	Invited     []User      `gorm:"many2many:trip_invited;"`
	Viewers     []User      `gorm:"many2many:trip_viewers;"`
	Editors     []User      `gorm:"many2many:trip_editors;"`
	Transports  []Transport `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE;foreignKey:TripID;"`
	Country     string      `gorm:"not null"`
	City        string      `gorm:"not null"`
	StartDate   time.Time   `gorm:"not null"`
	EndDate     time.Time   `gorm:"not null"`
	InviteCode  string      `gorm:"default:null;unique"`
}
