package models

import (
	"log"

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
