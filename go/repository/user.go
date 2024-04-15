package repository

import (
	"esgi69/challenge-flutter-go/models"

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
	u.Database.First(&user, id)
	if user.ID == 0 {
		return user, gorm.ErrRecordNotFound
	}
	return user, nil
}
