package errorHandlers

import (
	"challenge-flutter-go/logger"
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func HandleGormErrors(err error, context *gin.Context) {
	if errors.Is(err, gorm.ErrDuplicatedKey) {
		logger.ApiWarning(context, "Duplicated key")
		context.AbortWithStatusJSON(http.StatusConflict, gin.H{"error": "Duplicated key"})
		return
	}
	if errors.Is(err, gorm.ErrInvalidData) {
		logger.ApiError(context, "Invalid data")
		context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid data"})
		return
	}
	if errors.Is(err, gorm.ErrRecordNotFound) {
		logger.ApiInfo(context, "Record not found")
		context.AbortWithStatusJSON(http.StatusNotFound, gin.H{"error": "Record not found"})
		return
	}
	if errors.Is(err, gorm.ErrInvalidTransaction) {
		logger.ApiError(context, "Invalid transaction")
		context.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
		return
	}
	logger.ApiError(context, "Unknown GORM error")
	context.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
}
