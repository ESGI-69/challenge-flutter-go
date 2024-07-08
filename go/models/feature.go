package models

import (
	"gorm.io/gorm"
)

type Feature struct {
	gorm.Model
	Name         string `gorm:"not null;unique;max:64"`
	ModifiedByID uint
	ModifiedBy   User `gorm:"constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
	Enabled      bool
}
