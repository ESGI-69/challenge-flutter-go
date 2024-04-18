package errorHandlers

import (
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func HandleGormErrors(err error, context *gin.Context) {
	if errors.Is(err, gorm.ErrDuplicatedKey) {
		context.JSON(http.StatusConflict, gin.H{"error": "Duplicated key"})
		return
	}
	if errors.Is(err, gorm.ErrInvalidData) {
		context.JSON(http.StatusBadRequest, gin.H{"error": "Invalid data"})
		return
	}
	if errors.Is(err, gorm.ErrRecordNotFound) {
		context.JSON(http.StatusNotFound, gin.H{"error": "Record not found"})
		return
	}
	if errors.Is(err, gorm.ErrInvalidTransaction) {
		context.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
		return
	}
	context.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
}
