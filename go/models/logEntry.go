package models

import (
	"time"
)

type LogLevel string

const (
	LogLevelInfo  LogLevel = "INFO"
	LogLevelWarn  LogLevel = "WARN"
	LogLevelError LogLevel = "ERROR"
)

type LogEntry struct {
	ID        uint      `gorm:"primarykey"`
	Level     LogLevel  `gorm:"not null"`
	Message   string    `gorm:"not null"`
	Timestamp time.Time `gorm:"not null;autoCreateTime"`
}
