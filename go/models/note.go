package models

import (
	"gorm.io/gorm"
)

type Note struct {
	gorm.Model
	Title    string `gorm:"not null"`
	Content  string `gorm:"not null"`
	TripID   uint
	Trip     Trip `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
	AuthorId uint
	Author   User `gorm:"constraint:OnUpdate:CASCADE,OnDelete:SET NULL;"`
}

func (n *Note) UserIsAuthor(user *User) bool {
	return n.Author.ID == user.ID
}
