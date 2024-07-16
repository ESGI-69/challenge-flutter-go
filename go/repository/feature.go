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
	var featureNamesToHide []models.FeatureName = []models.FeatureName{
		models.FeatureNameAuth,
		models.FeatureNameTrip,
		models.FeatureNameUser,
	}

	for i := 0; i < len(features); i++ {
		for j := 0; j < len(featureNamesToHide); j++ {
			if features[i].Name == featureNamesToHide[j] {
				features = append(features[:i], features[i+1:]...)
				i--
				break
			}
		}
	}
	return
}

func (t *FeatureRepository) Get(name models.FeatureName) (feature models.Feature, err error) {
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
