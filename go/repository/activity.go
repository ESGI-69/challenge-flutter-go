package repository

import (
	"challenge-flutter-go/models"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type ActivityRepository struct {
	Database *gorm.DB
}

func (t *ActivityRepository) Get(id string) (activity models.Activity, err error) {
	err = t.Database.Preload(clause.Associations).First(&activity, id).Error
	return
}

func (t *ActivityRepository) Create(activity *models.Activity) error {
	return t.Database.Create(&activity).Error
}

func (t *ActivityRepository) Delete(id string) error {
	result := t.Database.Delete(&models.Activity{}, id)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}
	return result.Error
}

func (t *ActivityRepository) Update(activity *models.Activity) error {
	return t.Database.Save(&activity).Error
}

func (t *ActivityRepository) GetAllFromTrip(tripId string) (activities []models.Activity, err error) {
	err = t.Database.Where("trip_id = ?", tripId).Preload(clause.Associations).Find(&activities).Error
	return
}
