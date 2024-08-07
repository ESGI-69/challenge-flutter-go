package handlers

import (
	"challenge-flutter-go/api/errorHandlers"
	"challenge-flutter-go/api/responses"
	"challenge-flutter-go/models"
	"challenge-flutter-go/repository"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

type LogHandler struct {
	Repository repository.LogRepository
}

// @Summary		Get all logs
// @Description	Get all logs
// @Tags			log
// @Accept		json
// @Produce		json
// @Security		BearerAuth
// @Param		page	query	string	false	"Page number"
// @Param		filter	query	string	false	"Filter by log level"
// @Success		200		{object}	[]responses.LogResponse
// @Failure		400		{object}	error
// @Failure		401		{object}	error
// @Router		/logs [get]
func (handler *LogHandler) GetAll(context *gin.Context) {
	page := context.Query("page")
	filter := context.Query("filter")
	if filter != "" {
		if filter != string(models.LogLevelInfo) && filter != string(models.LogLevelWarn) && filter != string(models.LogLevelError) {
			context.JSON(http.StatusBadRequest, gin.H{"error": "Invalid filter"})
			return
		}
	}
	pageNumber, err := strconv.Atoi(page)
	if err != nil {
		pageNumber = 1
	}

	logs, err := handler.Repository.GetAll(pageNumber, 50, filter)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	logResponses := make([]responses.LogResponse, len(logs))
	for i, log := range logs {
		logResponses[i] = responses.LogResponse{
			ID:        log.ID,
			Message:   log.Message,
			Level:     log.Level,
			Timestamp: log.Timestamp.Format(time.RFC3339),
			Ip:        log.Ip,
			Path:      log.Path,
			Method:    log.Method,
			Username:  log.Username,
		}
	}

	context.JSON(http.StatusOK, logResponses)
}
