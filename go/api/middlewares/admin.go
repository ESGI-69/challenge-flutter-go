package middlewares

import (
	"challenge-flutter-go/api/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

func UserIsAdmin(context *gin.Context) {
	user, exists := utils.GetCurrentUser(context)

	if !exists {
		context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "User not found"})
		return
	}

	if !user.IsAdmin() {
		context.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "User is not an admin"})
		return
	}
}
