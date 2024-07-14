package models

import (
	"log"
	"strconv"
	"strings"

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
	Username           string   `gorm:"not null;unique"`
	Password           string   `gorm:"not null"`
	Role               UserRole `gorm:"not null; default:'USER'"`
	TripsEditor        []Trip   `gorm:"many2many:trip_editors;"`
	TripsViewer        []Trip   `gorm:"many2many:trip_viewers;"`
	TripsInvitations   []Trip   `gorm:"many2many:trip_invited;"`
	GoogleID           string
	ProfilePicturePath string
}

func (user *User) GetProfilePictureUri() string {
	if user.ProfilePicturePath == "" {
		return ""
	}
	return "/users/photo/" + strconv.FormatUint(uint64(user.ID), 10)
}

// Replace the current user password by hashing it
func (user *User) HashPassword() {
	if strings.HasPrefix(user.Password, "argon2$") {
		return
	}

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

func (user *User) BeforeSave(tx *gorm.DB) (err error) {
	user.HashPassword()
	return
}

func (user *User) IsAdmin() bool {
	return user.Role == UserRoleAdmin
}
