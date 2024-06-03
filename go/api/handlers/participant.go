package handlers

import (
	"challenge-flutter-go/api/errorHandlers"
	"challenge-flutter-go/api/responses"
	"challenge-flutter-go/api/utils"
	"challenge-flutter-go/repository"
	"net/http"

	"github.com/gin-gonic/gin"
)

type ParticipantHandler struct {
	TripRepository repository.TripRepository
	UserRepository repository.UserRepository
}

// @Summary	Change the role of a participant in a trip
// @Description	Only the owner of the trip can change the role of a participant
// @Tags		participants
// @Accept		json
// @Produce		json
// @Security	BearerAuth
// @Param		tripId	path	string	true	"ID of the trip"
// @Param		participantId	path	string	true	"ID of the participant"
// @Param		role	query	string	true	"Role of the participant"
// @Success	204
// @Failure	400	{object} error
// @Failure	401	{object} error
// @Router		/trips/{tripId}/participants/{participantId}/role [patch]
func (handler *ParticipantHandler) ChangeRole(context *gin.Context) {
	tripId := context.Param("id")
	participantId := context.Param("participantId")
	role := context.Query("role")

	if tripId == "" || participantId == "" || role == "" {
		context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Missing required parameters"})
		return
	}

	wantedRole := responses.StringToParticipantTripRole(role)

	if wantedRole == responses.ParticipantTripRoleNone || wantedRole == responses.ParticipantTripRoleOwner {
		context.JSON(http.StatusBadRequest, gin.H{"error": "Invalid role"})
		return
	}

	currentUser, exist := utils.GetCurrentUser(context)
	if !exist {
		return
	}

	trip, err := handler.TripRepository.Get(tripId)

	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	currentUserRole := handler.TripRepository.GetUserTripRole(trip, currentUser)

	if currentUserRole != responses.ParticipantTripRoleOwner {
		context.JSON(http.StatusUnauthorized, gin.H{"error": "Only the owner of the trip can change the role of a participant"})
		return
	}

	participantUser, err := handler.UserRepository.Get(participantId)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	participantRole := handler.TripRepository.GetUserTripRole(trip, participantUser)
	if participantRole == responses.ParticipantTripRoleNone {
		context.JSON(http.StatusBadRequest, gin.H{"error": "User is not part of the trip"})
		return
	}

	if participantRole == wantedRole {
		context.Status(http.StatusNoContent)
		return
	}

	if wantedRole == responses.ParticipantTripRoleEditor {
		handler.TripRepository.AddEditor(trip, participantUser)
		handler.TripRepository.RemoveViewer(trip, participantUser)
	}

	if wantedRole == responses.ParticipantTripRoleViewer {
		handler.TripRepository.AddViewer(trip, participantUser)
		handler.TripRepository.RemoveEditor(trip, participantUser)
	}

	context.Status(http.StatusNoContent)
}

// @Summary	Remove a participant from a trip
// @Description	Only the owner of the trip can remove a participant
// @Tags		participants
// @Accept		json
// @Produce		json
// @Security	BearerAuth
// @Param		id	path	string	true	"ID of the trip"
// @Param		participantId	path	string	true	"ID of the participant"
// @Success	204
// @Failure	400	{object} error
// @Failure	401	{object} error
// @Router		/trips/{id}/participants/{participantId} [delete]
func (handler *ParticipantHandler) RemoveParticipant(context *gin.Context) {
	tripId := context.Param("id")
	participantId := context.Param("participantId")

	if tripId == "" || participantId == "" {
		context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Missing required parameters"})
		return
	}

	currentUser, exist := utils.GetCurrentUser(context)
	if !exist {
		return
	}

	trip, err := handler.TripRepository.Get(tripId)

	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	currentUserRole := handler.TripRepository.GetUserTripRole(trip, currentUser)

	if currentUserRole != responses.ParticipantTripRoleOwner {
		context.JSON(http.StatusUnauthorized, gin.H{"error": "Only the owner of the trip can remove a participant"})
		return
	}

	participantUser, err := handler.UserRepository.Get(participantId)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	participantRole := handler.TripRepository.GetUserTripRole(trip, participantUser)
	if participantRole == responses.ParticipantTripRoleNone {
		context.JSON(http.StatusBadRequest, gin.H{"error": "User is not part of the trip"})
		return
	}

	if participantRole == responses.ParticipantTripRoleOwner {
		context.JSON(http.StatusBadRequest, gin.H{"error": "Owner cannot be removed from the trip"})
		return
	}

	if participantRole == responses.ParticipantTripRoleEditor {
		handler.TripRepository.RemoveEditor(trip, participantUser)
	}

	if participantRole == responses.ParticipantTripRoleViewer {
		handler.TripRepository.RemoveViewer(trip, participantUser)
	}

	context.Status(http.StatusNoContent)
}
