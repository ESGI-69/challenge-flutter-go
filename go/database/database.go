package database

import (
	"esgi69/challenge-flutter-go/config"
	"esgi69/challenge-flutter-go/models"
	"log"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var database *gorm.DB

func init() {
	dsn := "postgres://" + config.GetConfig().DBUser + ":" + config.GetConfig().DBPassword + "@" + config.GetConfig().DBHost + ":" + config.GetConfig().DBPort + "/" + config.GetConfig().DBName

	var databaseConnectionError error
	database, databaseConnectionError = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if databaseConnectionError != nil {
		log.Fatalln(databaseConnectionError)
	}
	defer log.Print("Database connection established")
	autoMigrate()
}

func autoMigrate() {
	defer log.Print("Database migrated")
	database.AutoMigrate(&models.User{})
}

func GetInstance() *gorm.DB {
	return database
}
