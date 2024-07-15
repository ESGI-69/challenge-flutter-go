package models

import (
	"time"
)

type FeatureName string

const (
	FeatureNameDocument      FeatureName = "document"
	FeatureNameAuth          FeatureName = "auth"
	FeatureNameChat          FeatureName = "chat"
	FeatureNameTrip          FeatureName = "trip"
	FeatureNameNote          FeatureName = "note"
	FeatureNameTransport     FeatureName = "transport"
	FeatureNameAccommodation FeatureName = "accommodation"
	FeatureNameUser          FeatureName = "user"
	FeatureNamePhoto         FeatureName = "photo"
	FeatureNameActivity      FeatureName = "activity"
)

type Feature struct {
	Name         FeatureName `gorm:"primarykey;not null;unique;max:64"`
	ModifiedByID uint
	ModifiedBy   User `gorm:"constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
	UpdatedAt    time.Time
	IsEnabled    bool
}
