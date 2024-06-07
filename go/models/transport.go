package models

import (
	"time"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type TransportType string

const (
	TransportTypeCar   TransportType = "car"
	TransportTypePlane TransportType = "plane"
	TransportTypeBus   TransportType = "bus"
)

type Transport struct {
	gorm.Model
	TransportType  TransportType `gorm:"not null; default:'car'"`
	StartDate      time.Time     `gorm:"not null"`
	TripID         uint
	Trip           Trip      `gorm:"constraint:OnUpdate:CASCADE"`
	EndDate        time.Time `gorm:"not null"`
	StartAddress   string    `gorm:"not null"`
	EndAddress     string    `gorm:"not null"`
	MeetingAddress string
	MeetingTime    time.Time
}

func (t *Transport) IsTransportTypeValid(context *gin.Context) (isValid bool) {
	isValid = t.TransportType == TransportTypeCar || t.TransportType == TransportTypePlane || t.TransportType == TransportTypeBus
	if !isValid {
		// Auto create a list of valid transport types
		context.AbortWithStatusJSON(400, gin.H{
			"error": "Invalid transport type",
			"valid": []string{"car", "plane", "bus"},
		})
	}
	return
}
