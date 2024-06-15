package models

import (
	// "challenge-flutter-go/api/utils"
	"log"
	"os"
	"path/filepath"

	"gorm.io/gorm"
)

type Document struct {
	gorm.Model
	Title       string `gorm:"not null"`
	Description string
	Path        string `gorm:"not null"`
	TripID      uint
	Trip        Trip `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE;"`
}

func (document *Document) AfterDelete(tx *gorm.DB) (err error) {
	baseDir := "uploads"
	specificDir := filepath.Join(baseDir, "documents")
	filePath := filepath.Join(specificDir, document.Path)

	err = os.Remove(filePath)
	if err != nil {
		log.Println(err)
		return err
	}

	return nil
}
