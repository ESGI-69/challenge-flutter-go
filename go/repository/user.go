package repository

import (
	"challenge-flutter-go/models"

	"gorm.io/gorm"
)

type UserRepository struct {
	Database *gorm.DB
}

func (u *UserRepository) Create(user models.User) (createdUser models.User, err error) {
	result := u.Database.Create(&user)
	return user, result.Error
}

func (u *UserRepository) Get(id string) (user models.User, err error) {
	err = u.Database.Preload("Trips").Preload("Trips.Owner").First(&user, id).Error
	return
}

func (u *UserRepository) FindByUsername(username string) (user models.User, err error) {
	err = u.Database.Where(&models.User{Username: username}).First(&user).Error
	return
}
