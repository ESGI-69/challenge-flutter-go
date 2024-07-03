package models

import (
	"time"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type AccommodationType string

const (
	AccommodationTypeHotel  AccommodationType = "hotel"
	AccommodationTypeAirbnb AccommodationType = "airbnb"
	AccommodationTypeOther  AccommodationType = "other"
)

type Accommodation struct {
	gorm.Model
	AccommodationType AccommodationType `gorm:"not null; default:'hotel'"`
	StartDate         time.Time         `gorm:"not null"`
	TripID            uint
	Trip              Trip      `gorm:"constraint:OnUpdate:CASCADE"`
	EndDate           time.Time `gorm:"not null"`
	Address           string    `gorm:"not null"`
	BookingURL        string    `gorm:"null"`
	Name              string    `gorm:"not null"`
	Latitude          float64   `gorm:"null"`
	Longitude         float64   `gorm:"null"`
}

func (a *Accommodation) IsAccommodationTypeValid(context *gin.Context) (isValid bool) {
	isValid = a.AccommodationType == AccommodationTypeHotel || a.AccommodationType == AccommodationTypeAirbnb || a.AccommodationType == AccommodationTypeOther
	if !isValid {
		// Auto create a list of valid accommodation types
		context.AbortWithStatusJSON(400, gin.H{
			"error": "Invalid accommodation type",
			"valid": []string{"hotel", "airbnb", "other"},
		})
	}
	return
}
