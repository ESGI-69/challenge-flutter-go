package repository

import (
	"challenge-flutter-go/models"

	"gorm.io/gorm"
)

type FeatureRepository struct {
	Database *gorm.DB
}

func (t *FeatureRepository) Create(feature *models.Feature) error {
	return t.Database.Create(&feature).Error
}

func (t *FeatureRepository) GetFeatures() (features []models.Feature, err error) {
	err = t.Database.Preload("ModifiedBy").Order("name ASC").Find(&features).Error
	for i, feature := range features {
		if feature.Name == models.FeatureNameTrip {
			features = append(features[:i], features[i+1:]...)
			break
		}
	}
	return
}

func (t *FeatureRepository) Get(name string) (feature models.Feature, err error) {
	err = t.Database.Preload("ModifiedBy").First(&feature, "name = ?", name).Error
	return
}

func (t *FeatureRepository) Update(feature *models.Feature) (err error) {
	return t.Database.Save(&feature).Preload("ModifiedBy").Error
}

func (t *FeatureRepository) Delete(id string) error {
	result := t.Database.Delete(&models.Feature{}, id)
	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}
	return result.Error
}
