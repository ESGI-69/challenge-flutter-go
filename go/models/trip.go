package models

import (
	"time"

	"gorm.io/gorm"
)

type Trip struct {
	gorm.Model
	Name         string `gorm:"not null"`
	Description  string
	OwnerID      uint
	Owner        User      `gorm:"constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
	Participants []User    `gorm:"many2many:trip_participants;"`
	Country      string    `gorm:"not null"`
	City         string    `gorm:"not null"`
	StartDate    time.Time `gorm:"not null"`
	EndDate      time.Time `gorm:"not null"`
	InviteCode   string    `gorm:"default:null;unique"`
}

type TripParticipantRole string

const (
	TripParticipantRoleEditor TripParticipantRole = "EDITOR"
	TripParticipantRoleGuest  TripParticipantRole = "GUEST"
)

type TripParticipant struct {
	TripID uint
	UserID uint
	Role   TripParticipantRole `gorm:"not null; default:'GUEST'"`
}
