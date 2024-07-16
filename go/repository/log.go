package repository

import (
	"challenge-flutter-go/models"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type LogRepository struct {
	Database *gorm.DB
}

// Get all logs
func (l *LogRepository) GetAll(page int, pageSize int, filter string) (logs []models.LogEntry, err error) {
	offset := (page - 1) * pageSize
	query := l.Database.Preload(clause.Associations).Offset(offset).Limit(pageSize).Order("timestamp DESC")
	if filter != "" {
		query = query.Where("level = ?", filter)
	}
	err = query.Find(&logs).Error
	return
}
