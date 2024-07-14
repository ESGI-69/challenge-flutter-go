package repository

import (
	"challenge-flutter-go/models"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type LogRepository struct {
	Database *gorm.DB
}

// Get all logs (might have filters after)
func (l *LogRepository) GetAll(page int, pageSize int) (logs []models.LogEntry, err error) {
	offset := (page - 1) * pageSize
	err = l.Database.Preload(clause.Associations).Offset(offset).Limit(pageSize).Find(&logs).Error
	return
}
