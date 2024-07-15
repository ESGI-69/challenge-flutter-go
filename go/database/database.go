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
	database, databaseConnectionError = gorm.Open(postgres.Open(dsn), &gorm.Config{TranslateError: true})
	if databaseConnectionError != nil {
		log.Fatalln(databaseConnectionError)
	}
	defer log.Print("Database connection established")
	autoMigrate()
	createAdminUser()
	createFeatures()
}

func autoMigrate() {
	defer log.Print("Database migrated")
	err := database.AutoMigrate(
		&models.User{},
		&models.Trip{},
		&models.Transport{},
		&models.Note{},
		&models.ChatMessage{},
		&models.Accommodation{},
		&models.Document{},
		&models.Photo{},
		&models.LogEntry{},
		&models.Feature{},
		&models.Activity{},
	)
	if err != nil {
		log.Fatalln(err)
	}
}

func createAdminUser() {
	user := models.User{
		Username: "admin",
		Password: "admin",
		Role:     models.UserRoleAdmin,
	}

	database.First(&user, "username = ?", user.Username)

	if user.ID == 0 {
		database.Create(&user)
	} else {
		log.Print("Admin user already exists, enforcing password")
		user.Password = "admin"
		user.Role = models.UserRoleAdmin
		database.Save(&user)
	}
}

func createFeatures() {
	user := models.User{
		Username: "admin",
	}

	database.First(&user, "username = ?", user.Username)

	features := []models.Feature{
		{
			Name:       models.FeatureNameDocument,
			IsEnabled:  true,
			ModifiedBy: user,
		},
		{
			Name:       models.FeatureNameAuth,
			IsEnabled:  true,
			ModifiedBy: user,
		},
		{
			Name:       models.FeatureNameChat,
			IsEnabled:  true,
			ModifiedBy: user,
		},
		{
			Name:       models.FeatureNameTrip,
			IsEnabled:  true,
			ModifiedBy: user,
		},
		{
			Name:       models.FeatureNameNote,
			IsEnabled:  true,
			ModifiedBy: user,
		},
		{
			Name:       models.FeatureNameTransport,
			IsEnabled:  true,
			ModifiedBy: user,
		},
		{
			Name:       models.FeatureNameAccommodation,
			IsEnabled:  true,
			ModifiedBy: user,
		},
		{
			Name:       models.FeatureNameUser,
			IsEnabled:  true,
			ModifiedBy: user,
		},
		{
			Name:       models.FeatureNamePhoto,
			IsEnabled:  true,
			ModifiedBy: user,
		},
		{
			Name:       models.FeatureNameActivity,
			IsEnabled:  true,
			ModifiedBy: user,
		},
	}

	for _, feature := range features {
		var existingFeature models.Feature
		result := database.First(&existingFeature, "name = ?", feature.Name)
		if result.Error != nil {
			database.Create(&feature)
			log.Print("Feature " + feature.Name + " created and enabled")
		}
	}
}

func GetInstance() *gorm.DB {
	return database
}
