package handler

import (
	"challenge-flutter-go/repository"
	"net/http"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type UserHandler struct {
	Repository repository.UserRepository
}

func (handler *UserHandler) Get(context *gin.Context) {
	id := context.Param("id")

	user, err := handler.Repository.Get(id)

	if err == gorm.ErrRecordNotFound {
		context.JSON(http.StatusNotFound, gin.H{"error": "User with id " + id + " not found"})
		return
	}
	if err != nil {
		context.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
		return
	}

	context.JSON(http.StatusOK, user)
}
