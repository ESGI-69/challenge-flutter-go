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

func (t *Trip) IsOwner(user *User) bool {
	return t.OwnerID == user.ID
}

func (t *Trip) HasEditRight(user *User) bool {
	isOwner := t.IsOwner(user)
	isEditor := false
	for _, editor := range t.Editors {
		if editor.ID == user.ID {
			isEditor = true
		}
	}
	return isOwner || isEditor
}
