package repository

import (
	"challenge-flutter-go/models"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type ChatMessageRepository struct {
	Database *gorm.DB
}

// Create a chat message & associate it with a trip and an author
func (c *ChatMessageRepository) Create(chatMessage *models.ChatMessage) error {
	return c.Database.Create(&chatMessage).Preload(clause.Associations).First(&chatMessage).Error
}

// Get all the chat messages of a trip
func (c *ChatMessageRepository) GetAllFromTrip(trip models.Trip) (chatMessages []models.ChatMessage, err error) {
	err = c.Database.Preload("Author").Model(&models.ChatMessage{}).Where("trip_id = ?", trip.ID).Find(&chatMessages).Error
	return
}

// Delete a chat message from a trip
func (c *ChatMessageRepository) Delete(trip models.Trip, chatMessageID uint) (err error) {
	result := c.Database.Delete(&models.ChatMessage{}, chatMessageID)
	return result.Error
}
