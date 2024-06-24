package models

import (
	"errors"
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

func (document *Document) BeforeDelete(tx *gorm.DB) (err error) {
	if document.Path == "" {
		err = errors.New("document path is empty")
		return err
	}

	baseDir := "uploads"
	specificDir := filepath.Join(baseDir, "documents")
	filePath := filepath.Join(specificDir, document.Path)

	err = os.Remove(filePath)

	if err != nil {
		return err
	}

	return nil
}
