package handlers

import (
	"challenge-flutter-go/api/errorHandlers"
	"challenge-flutter-go/api/utils"
	"challenge-flutter-go/models"
	"challenge-flutter-go/repository"
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

type TripHandler struct {
	Repository repository.TripRepository
}

// Create a new trip & associate it with the current user
func (handler *TripHandler) Create(context *gin.Context) {
	type RequestBody struct {
		Name      string `json:"name" binding:"required"`
		Country   string `json:"country" binding:"required"`
		City      string `json:"city" binding:"required"`
		StartDate string `json:"startDate" binding:"required"`
		EndDate   string `json:"endDate" binding:"required"`
	}

	var requestBody RequestBody
	isBodyValid := utils.Deserialize(&requestBody, context)
	if !isBodyValid {
		return
	}

	currentUser, exist := utils.GetCurrentUser(context)
	if !exist {
		return
	}

	startDate, startDateParseError := time.Parse(time.RFC3339, requestBody.StartDate)
	if startDateParseError != nil {
		fmt.Println(startDateParseError)
		context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid start date"})
		return
	}

	endDate, endDateParseError := time.Parse(time.RFC3339, requestBody.EndDate)
	if endDateParseError != nil {
		context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid end date"})
		return
	}

	trip := models.Trip{
		Name:      requestBody.Name,
		Country:   requestBody.Country,
		City:      requestBody.City,
		Owner:     currentUser,
		StartDate: startDate,
		EndDate:   endDate,
	}

	createdTrip, err := handler.Repository.Create(trip)

	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	context.JSON(http.StatusCreated, createdTrip)
}
