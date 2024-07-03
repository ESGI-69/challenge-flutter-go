package models

import (
	"gorm.io/gorm"
)

type ChatMessage struct {
	gorm.Model
	Content  string `gorm:"not null"`
	AuthorID uint
	Author   User `gorm:"constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
	TripID   uint
	Trip     Trip `gorm:"constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
}

func (chatMsg ChatMessage) GetTripID() uint {
	return chatMsg.TripID
}
