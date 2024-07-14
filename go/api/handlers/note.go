package handlers

import (
	"challenge-flutter-go/api/errorHandlers"
	"challenge-flutter-go/api/requests"
	"challenge-flutter-go/api/responses"
	"challenge-flutter-go/api/utils"
	"challenge-flutter-go/logger"
	"challenge-flutter-go/models"
	"challenge-flutter-go/repository"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

type NoteHandler struct {
	Repository     repository.NoteRepository
	TripRepository repository.TripRepository
}

// @Summary		Get all notes of a trip
// @Description	Get all notes of a trip
// @Tags			note
// @Accept			json
// @Produce		json
// @Security		BearerAuth
// @Param			id		path		string	true	"ID of the trip"
// @Success		200		{object}	responses.NoteResponse
// @Failure		400		{object}	error
// @Failure		401		{object}	error
// @Router			/trips/{id}/notes [get]
func (handler *NoteHandler) GetNotesOfTrip(context *gin.Context) {
	tripId := context.Param("id")

	trip, _ := handler.TripRepository.Get(tripId)

	notes, err := handler.Repository.GetNotes(trip)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	noteResponses := make([]responses.NoteResponse, len(notes))
	for i, note := range notes {
		noteResponses[i] = responses.NoteResponse{
			ID:      note.ID,
			Title:   note.Title,
			Content: note.Content,
			Author: responses.UserResponse{
				ID:                 note.Author.ID,
				Username:           note.Author.Username,
				ProfilePicturePath: note.Author.ProfilePicturePath,
				ProfilePictureUri:  note.Author.GetProfilePictureUri(),
			},
			CreatedAt: note.CreatedAt.Format(time.RFC3339),
			UpdateAt:  note.UpdatedAt.Format(time.RFC3339),
		}
	}
	context.JSON(http.StatusOK, noteResponses)
	logger.ApiInfo(context, "Get all notes from trip "+tripId)
}

// @Summary		Create a new note on trip
// @Description	Create a new note & associate it with the trip
// @Tags			note
// @Accept			json
// @Produce		json
// @Security		BearerAuth
// @Param			id		path		string	true	"ID of the trip"
// @Param			body	body		requests.NoteCreateBody	true	"Body of the note"
// @Success		201		{object}	responses.NoteResponse
// @Failure		400		{object}	error
// @Failure		401		{object}	error
// @Router			/trips/{id}/notes [post]
func (handler *NoteHandler) AddNoteToTrip(context *gin.Context) {
	tripId := context.Param("id")

	var requestBody requests.NoteCreateBody
	isBodyValid := utils.Deserialize(&requestBody, context)
	if !isBodyValid {
		return
	}

	currentUser, _ := utils.GetCurrentUser(context)

	trip, _ := handler.TripRepository.Get(tripId)

	var note = models.Note{
		Title:   requestBody.Title,
		Content: requestBody.Content,
		Author:  currentUser,
		TripID:  trip.ID,
	}

	err := handler.Repository.Create(&note)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	noteResponse := responses.NoteResponse{
		ID:      note.ID,
		Title:   note.Title,
		Content: note.Content,
		Author: responses.UserResponse{
			ID:                 note.Author.ID,
			Username:           note.Author.Username,
			ProfilePicturePath: note.Author.ProfilePicturePath,
			ProfilePictureUri:  note.Author.GetProfilePictureUri(),
		},
		CreatedAt: note.CreatedAt.Format(time.RFC3339),
		UpdateAt:  note.UpdatedAt.Format(time.RFC3339),
	}

	context.JSON(http.StatusCreated, noteResponse)
	logger.ApiInfo(context, "Note "+note.Title+" added to trip "+tripId)
}

// @Summary		Delete a note from trip
// @Description	Delete a note from the trip
// @Tags			note
// @Accept			json
// @Produce		json
// @Security		BearerAuth
// @Param			id		path		string	true	"ID of the trip"
// @Param			noteID	path		string	true	"ID of the note"
// @Success		204		{object}	error
// @Failure		400		{object}	error
// @Failure		401		{object}	error
// @Failure		404		{object}	error
// @Router			/trips/{id}/notes/{noteID} [delete]
func (handler *NoteHandler) DeleteNoteFromTrip(context *gin.Context) {
	tripId := context.Param("id")

	noteID := context.Param("noteID")
	if noteID == "" {
		logger.ApiWarning(context, "No note ID provided")
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	currentUser, _ := utils.GetCurrentUser(context)

	trip, _ := handler.TripRepository.Get(tripId)

	note, errNote := handler.Repository.Get(noteID)
	if errNote != nil {
		errorHandlers.HandleGormErrors(errNote, context)
		return
	}

	isUserAuthor := note.UserIsAuthor(&currentUser)

	if !isUserAuthor {
		logger.ApiWarning(context, "Only the author of the note "+noteID+" can remove them")
		context.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{
			"message": "Only the author of the node can remove them",
		})
		return
	}

	errDelete := handler.Repository.DeleteNote(trip, note.ID)
	if errDelete != nil {
		errorHandlers.HandleGormErrors(errDelete, context)
		return
	}

	context.Status(http.StatusNoContent)
	logger.ApiInfo(context, "Note "+noteID+" removed from trip "+tripId)
}
