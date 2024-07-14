package repository

import (
	"challenge-flutter-go/models"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type ActivityRepository struct {
	Database *gorm.DB
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

func (t *ActivityRepository) Update(activityId string, activity *models.Activity) error {
	result := t.Database.Model(&models.Activity{}).Where("id = ?", activityId).Updates(activity)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}
	result.Preload(clause.Associations).Find(&activity)
	return result.Error
}

func (t *ActivityRepository) GetAllFromTrip(tripId string) (activities []models.Activity, err error) {
	err = t.Database.Where("trip_id = ?", tripId).Preload(clause.Associations).Find(&activities).Error
	return
}
