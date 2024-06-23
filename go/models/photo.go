package models

import (
	"errors"
	"log"
	"os"
	"path/filepath"

	"gorm.io/gorm"
)

type Photo struct {
	gorm.Model
	Title       string `gorm:"not null"`
	Description string
	Path        string `gorm:"not null"`
	TripID      uint
	Trip        Trip `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}

func (photo *Photo) BeforeDelete(tx *gorm.DB) (err error) {
	if photo.Path == "" {
		err = errors.New("photo path is empty")
		return err
	}

	baseDir := "uploads"
	specificDir := filepath.Join(baseDir, "photos")
	filePath := filepath.Join(specificDir, photo.Path)

	err = os.Remove(filePath)

	if err != nil {
		log.Println(err)
		return err
	}

	return nil
}
