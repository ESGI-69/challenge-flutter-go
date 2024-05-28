package models

import (
	"log"
	"time"

	"github.com/raja/argon2pw"
	"gorm.io/gorm"
)

type UserRole string

const (
	UserRoleAdmin UserRole = "ADMIN"
	UserRoleUser  UserRole = "USER"
)

type User struct {
	gorm.Model
	Username string   `gorm:"not null;unique"`
	Password string   `gorm:"not null"`
	Trips    []Trip   `gorm:"many2many:trip_participants;"`
	Role     UserRole `gorm:"not null; default:'USER'"`
	GoogleID string
}

// Replace the current user password by hashing it
func (user *User) HashPassword() {
	hashedPassword, err := argon2pw.GenerateSaltedHash(user.Password)
	if err != nil {
		log.Panicf("Error while hashing the password of %s", user.Username)
	}
	user.Password = hashedPassword
}

func (user *User) CheckPassword(password string) (isSame bool) {
	isSame, _ = argon2pw.CompareHashWithPassword(user.Password, password)
	return
}

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

type TransportType string

const (
	TransportTypeCar   TransportType = "car"
	TransportTypePlane TransportType = "plane"
	TransportTypeBus   TransportType = "bus"
)

type Transport struct {
	gorm.Model
	TransportType TransportType `gorm:"not null; default:'car'"`
	StartDate     time.Time     `gorm:"not null"`
	TripID        uint
	Trip          Trip      `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	EndDate       time.Time `gorm:"not null"`
	StartAddress  string    `gorm:"not null"`
	EndAddress    string    `gorm:"not null"`
}
