package models

import (
	"time"

	"gorm.io/gorm"
)

type Trip struct {
	gorm.Model
	Name           string `gorm:"not null"`
	Description    string
	OwnerID        uint
	Owner          User            `gorm:"constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
	Invited        []User          `gorm:"many2many:trip_invited;"`
	Viewers        []User          `gorm:"many2many:trip_viewers;"`
	Editors        []User          `gorm:"many2many:trip_editors;"`
	Transports     []Transport     `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE;foreignKey:TripID;"`
	Accommodations []Accommodation `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE;foreignKey:TripID;"`
	Country        string          `gorm:"not null"`
	City           string          `gorm:"not null"`
	StartDate      time.Time       `gorm:"not null"`
	EndDate        time.Time       `gorm:"not null"`
	InviteCode     string          `gorm:"default:null;unique"`
}

func (t *Trip) UserIsOwner(user *User) bool {
	return t.OwnerID == user.ID
}

func (t *Trip) UserIsEditor(user *User) bool {
	isEditor := false
	for _, editor := range t.Editors {
		if editor.ID == user.ID {
			isEditor = true
		}
	}
	return isEditor
}

func (t *Trip) UserHasEditRight(user *User) bool {
	return t.UserIsEditor(user) || t.UserIsOwner(user)
}

func (t *Trip) UserIsViewer(user *User) bool {
	isViewer := false
	for _, viewer := range t.Viewers {
		if viewer.ID == user.ID {
			isViewer = true
		}
	}
	return isViewer
}

func (t *Trip) UserHasViewRight(user *User) bool {
	return t.UserIsViewer(user) || t.UserHasEditRight(user)
}
