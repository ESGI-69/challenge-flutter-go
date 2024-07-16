package middlewares

import (
	"challenge-flutter-go/api/errorHandlers"
	"challenge-flutter-go/database"
	"challenge-flutter-go/models"
	"challenge-flutter-go/repository"

	"github.com/gin-gonic/gin"
)

var featureRepository = repository.FeatureRepository{
	Database: database.GetInstance(),
}

func IsAccomodationFeatureEnabled(context *gin.Context) {
	isEnabled, err := isFeatureEnabled(models.FeatureNameAccommodation)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	if !isEnabled {
		context.AbortWithStatusJSON(403, gin.H{"error": "Feature not enabled"})
		return
	}
	context.Next()
}

func IsActivityFeatureEnabled(context *gin.Context) {
	isEnabled, err := isFeatureEnabled(models.FeatureNameActivity)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	if !isEnabled {
		context.AbortWithStatusJSON(403, gin.H{"error": "Feature not enabled"})
		return
	}
	context.Next()
}

func IsAuthFeatureEnabled(context *gin.Context) {
	isEnabled, err := isFeatureEnabled(models.FeatureNameAuth)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	if !isEnabled {
		context.AbortWithStatusJSON(403, gin.H{"error": "Feature not enabled"})
		return
	}
	context.Next()
}

func IsChatFeatureEnabled(context *gin.Context) {
	isEnabled, err := isFeatureEnabled(models.FeatureNameChat)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	if !isEnabled {
		context.AbortWithStatusJSON(403, gin.H{"error": "Feature not enabled"})
		return
	}
	context.Next()
}

func IsDocumentFeatureEnabled(context *gin.Context) {
	isEnabled, err := isFeatureEnabled(models.FeatureNameDocument)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	if !isEnabled {
		context.AbortWithStatusJSON(403, gin.H{"error": "Feature not enabled"})
		return
	}
	context.Next()
}

func IsNoteFeatureEnabled(context *gin.Context) {
	isEnabled, err := isFeatureEnabled(models.FeatureNameNote)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	if !isEnabled {
		context.AbortWithStatusJSON(403, gin.H{"error": "Feature not enabled"})
		return
	}
	context.Next()
}

func IsPhotoFeatureEnabled(context *gin.Context) {
	isEnabled, err := isFeatureEnabled(models.FeatureNamePhoto)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	if !isEnabled {
		context.AbortWithStatusJSON(403, gin.H{"error": "Feature not enabled"})
		return
	}
	context.Next()
}

func IsTransportFeatureEnabled(context *gin.Context) {
	isEnabled, err := isFeatureEnabled(models.FeatureNameTransport)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	if !isEnabled {
		context.AbortWithStatusJSON(403, gin.H{"error": "Feature not enabled"})
		return
	}
	context.Next()
}

func IsTripFeatureEnabled(context *gin.Context) {
	isEnabled, err := isFeatureEnabled(models.FeatureNameTrip)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	if !isEnabled {
		context.AbortWithStatusJSON(403, gin.H{"error": "Feature not enabled"})
		return
	}
	context.Next()
}

func IsUserFeatureEnabled(context *gin.Context) {
	isEnabled, err := isFeatureEnabled(models.FeatureNameUser)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	if !isEnabled {
		context.AbortWithStatusJSON(403, gin.H{"error": "Feature not enabled"})
		return
	}
	context.Next()
}

func isFeatureEnabled(featureName models.FeatureName) (isEnabled bool, err error) {
	var feature models.Feature
	feature, err = featureRepository.Get(featureName)
	if err != nil {
		return false, err
	}
	return feature.IsEnabled, nil
}
