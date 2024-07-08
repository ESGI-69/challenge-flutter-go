package models

import (
	"time"
)

type FeatureName string

const (
	FeatureNameDocument      = "document"
	FeatureNameAuth          = "auth"
	FeatureNameChat          = "chat"
	FeatureNameTrip          = "trip"
	FeatureNameNote          = "note"
	FeatureNameTransport     = "transport"
	FeatureNameAccommodation = "accommodation"
	FeatureNameUser          = "user"
)

type Feature struct {
	Name         FeatureName `gorm:"primarykey;not null;unique;max:64"`
	ModifiedByID uint
	ModifiedBy   User `gorm:"constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
	UpdatedAt    time.Time
	IsEnabled    bool
}
