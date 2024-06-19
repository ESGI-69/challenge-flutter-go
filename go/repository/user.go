package repository

import (
	"challenge-flutter-go/models"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type UserRepository struct {
	Database *gorm.DB
}

func (u *UserRepository) Create(user *models.User) (err error) {
	return u.Database.Create(&user).Error
}

// Used to retrive a user from his ID with all this direct relations preloaded
func (u *UserRepository) Get(id string) (user models.User, err error) {
	err = u.Database.Model(&models.User{}).Preload(clause.Associations).First(&user, id).Error
	return
}

func (u *UserRepository) FindByUsername(username string) (user models.User, err error) {
	err = u.Database.Where(&models.User{Username: username}).First(&user).Error
	return
}

func (u *UserRepository) ComparePassword(user models.User, password string) (isSame bool) {
	return user.CheckPassword(password)
}

func (u *UserRepository) UserExists(username string) (bool, error) {
	var user models.User
	err := u.Database.Where("username = ?", username).First(&user).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return false, nil
		}
		return false, err
	}
	return true, nil
}
