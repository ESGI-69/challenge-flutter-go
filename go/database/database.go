package database

import (
	"challenge-flutter-go/config"
	"challenge-flutter-go/models"
	"log"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var database *gorm.DB

func init() {
	dsn := "host=" + config.GetConfig().DBHost + " user=" + config.GetConfig().DBUser + " password=" + config.GetConfig().DBPassword + " dbname=" + config.GetConfig().DBName + " port=" + config.GetConfig().DBPort + " sslmode=disable"

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
	err := database.AutoMigrate(
		&models.User{},
		&models.Trip{},
		&models.TripParticipant{},
		&models.Transport{},
	)
	if err != nil {
		log.Fatalln(err)
	}
}

func GetInstance() *gorm.DB {
	return database
}
