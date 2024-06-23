package errorHandlers

import (
	"challenge-flutter-go/logger"
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgconn"
	"gorm.io/gorm"
)

func HandleGormErrors(err error, context *gin.Context) {
	if err == nil {
		return
	}

	var postgresErr *pgconn.PgError
	if errors.As(err, &postgresErr) && postgresErr.Code == "23505" { // PostgreSQL error code for unique violation
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
	context.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
}
