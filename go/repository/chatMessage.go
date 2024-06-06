package repository

import (
	"challenge-flutter-go/models"

	"gorm.io/gorm"
)

type ChatMessageRepository struct {
	Database *gorm.DB
}

// Create a chat message & associate it with a trip and an author
func (c *ChatMessageRepository) AddChatMessage(trip models.Trip, chatMessage models.ChatMessage) (models.ChatMessage, error) {
	chatMessage.TripID = trip.ID

	result := c.Database.Create(&chatMessage)
	if result.Error != nil {
		return models.ChatMessage{}, result.Error
	}
	//add associations
	c.Database.Model(&chatMessage).Association("Trip").Append(&trip)
	return chatMessage, nil
}

// Get all the chat messages of a trip
func (c *ChatMessageRepository) GetChatMessages(trip models.Trip) (chatMessages []models.ChatMessage, err error) {
	err = c.Database.Preload("Author").Model(&models.ChatMessage{}).Where("trip_id = ?", trip.ID).Find(&chatMessages).Error
	return
}

// Delete a chat message from a trip
func (c *ChatMessageRepository) DeleteChatMessage(trip models.Trip, chatMessageID uint) (err error) {
	result := c.Database.Delete(&models.ChatMessage{}, chatMessageID)
	return result.Error
}
