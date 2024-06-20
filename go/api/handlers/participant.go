package handlers

import (
	"challenge-flutter-go/api/errorHandlers"
	"challenge-flutter-go/api/responses"
	"challenge-flutter-go/logger"
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
// @Param		id	path	string	true	"ID of the trip"
// @Param		participantId	path	string	true	"ID of the participant"
// @Param		role	query	string	true	"Role of the participant"
// @Success	204
// @Failure	400	{object} error
// @Failure	401	{object} error
// @Router		/trips/{id}/participants/{participantId}/role [patch]
func (handler *ParticipantHandler) ChangeRole(context *gin.Context) {
	tripId := context.Param("id")
	participantId := context.Param("participantId")
	role := context.Query("role")

	if participantId == "" || role == "" {
		logger.ApiWarning(context, "Missing required parameters")
		context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Missing required parameters"})
		return
	}

	wantedRole := responses.StringToParticipantTripRole(role)

	if wantedRole == responses.ParticipantTripRoleNone || wantedRole == responses.ParticipantTripRoleOwner {
		logger.ApiWarning(context, "Invalid role "+role)
		context.JSON(http.StatusBadRequest, gin.H{"error": "Invalid role"})
		return
	}

	trip, err := handler.TripRepository.Get(tripId)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	participantUser, err := handler.UserRepository.Get(participantId)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	if !trip.UserHasViewRight(&participantUser) {
		logger.ApiWarning(context, "User "+participantId+" to change role is not part of the trip")
		context.JSON(http.StatusBadRequest, gin.H{"error": "User is not part of the trip"})
		return
	}

	if wantedRole == responses.ParticipantTripRoleEditor {
		handler.TripRepository.AddEditor(&trip, participantUser)
		handler.TripRepository.RemoveViewer(&trip, participantUser)
	}

	if wantedRole == responses.ParticipantTripRoleViewer {
		handler.TripRepository.AddViewer(&trip, participantUser)
		handler.TripRepository.RemoveEditor(&trip, participantUser)
	}

	context.Status(http.StatusNoContent)
	logger.ApiInfo(context, "Role of participant "+participantId+" in trip "+tripId+" changed to "+role)
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

	if participantId == "" {
		logger.ApiWarning(context, "Missing required parameters")
		context.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Missing required parameters"})
		return
	}

	trip, _ := handler.TripRepository.Get(tripId)

	participantUser, err := handler.UserRepository.Get(participantId)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	if !trip.UserHasViewRight(&participantUser) {
		logger.ApiWarning(context, "User "+participantId+" to remove is not part of the trip")
		context.JSON(http.StatusBadRequest, gin.H{"error": "User is not part of the trip"})
		return
	}

	if trip.UserIsOwner(&participantUser) {
		logger.ApiWarning(context, "Owner cannot be removed from the trip")
		context.JSON(http.StatusBadRequest, gin.H{"error": "Owner cannot be removed from the trip"})
		return
	}

	if trip.UserIsEditor(&participantUser) {
		handler.TripRepository.RemoveEditor(&trip, participantUser)
	}

	if trip.UserIsViewer(&participantUser) {
		handler.TripRepository.RemoveViewer(&trip, participantUser)
	}

	context.Status(http.StatusNoContent)
	logger.ApiInfo(context, "Participant "+participantId+" removed from trip "+tripId)
}
