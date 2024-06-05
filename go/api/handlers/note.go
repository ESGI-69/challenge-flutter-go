package handlers

import (
	"challenge-flutter-go/api/errorHandlers"
	"challenge-flutter-go/api/requests"
	"challenge-flutter-go/api/responses"
	"challenge-flutter-go/api/utils"
	"challenge-flutter-go/models"
	"challenge-flutter-go/repository"
	"net/http"

	"github.com/gin-gonic/gin"
)

type NoteHandler struct {
	Repository     repository.NoteRepository
	TripRepository repository.TripRepository
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
	id := context.Param("id")
	if id == "" {
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	var requestBody requests.NoteCreateBody
	isBodyValid := utils.Deserialize(&requestBody, context)
	if !isBodyValid {
		return
	}

	currentUser, exist := utils.GetCurrentUser(context)
	if !exist {
		context.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
	}

	trip, err := handler.TripRepository.Get(id)

	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	isUserHasViewRights := handler.TripRepository.HasViewRight(trip, currentUser)

	if !isUserHasViewRights {
		if trip.OwnerID != currentUser.ID {
			context.AbortWithStatus(http.StatusUnauthorized)
			return
		}
	}

	var note = models.Note{
		Title:   requestBody.Title,
		Content: requestBody.Content,
		Author:  currentUser,
	}

	var noteCreated, errNote = handler.Repository.AddNote(trip, note)

	if errNote != nil {
		errorHandlers.HandleGormErrors(errNote, context)
		return
	}

	noteResponse := responses.NoteResponse{
		ID:      noteCreated.ID,
		Title:   noteCreated.Title,
		Content: noteCreated.Content,
	}

	context.JSON(http.StatusCreated, noteResponse)
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
	id := context.Param("id")
	if id == "" {
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	noteID := context.Param("noteID")
	if noteID == "" {
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}

	currentUser, exist := utils.GetCurrentUser(context)
	if !exist {
		context.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	trip, errTrip := handler.TripRepository.Get(id)
	if errTrip != nil {
		errorHandlers.HandleGormErrors(errTrip, context)
		return
	}

	note, errNote := handler.Repository.Get(noteID)
	if errNote != nil {
		errorHandlers.HandleGormErrors(errNote, context)
		return
	}

	isUserHasEditRights := handler.TripRepository.HasEditRight(trip, currentUser)
	isUserAuthor := handler.Repository.IsAuthor(note, currentUser)

	if !isUserHasEditRights && !isUserAuthor && trip.OwnerID != currentUser.ID {
		context.AbortWithStatus(http.StatusUnauthorized)
		return
	}

	errDelete := handler.Repository.DeleteNote(trip, note.ID)
	if errDelete != nil {
		errorHandlers.HandleGormErrors(errDelete, context)
		return
	}

	context.JSON(http.StatusNoContent, nil)
}
