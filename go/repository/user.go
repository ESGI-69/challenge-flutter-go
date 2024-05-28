package repository

import (
	"challenge-flutter-go/models"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type UserRepository struct {
	Database *gorm.DB
}

func (u *UserRepository) Create(user models.User) (createdUser models.User, err error) {
	user.HashPassword()
	result := u.Database.Create(&user)
	return user, result.Error
}

// Used to retrive a user from his ID with all this direct relations preloaded
func (u *UserRepository) Get(id string) (user models.User, err error) {
	err = u.Database.Preload(clause.Associations).Preload("Trips.Owner").First(&user, id).Error
	return
}

func (u *UserRepository) FindByUsername(username string) (user models.User, err error) {
	err = u.Database.Where(&models.User{Username: username}).First(&user).Error
	return
}

func (u *UserRepository) ComparePassword(user models.User, password string) (isSame bool) {
	return user.CheckPassword(password)
}
