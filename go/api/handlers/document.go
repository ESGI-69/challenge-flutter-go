package handlers

import (
	"challenge-flutter-go/api/errorHandlers"
	"challenge-flutter-go/api/responses"
	"challenge-flutter-go/models"
	"challenge-flutter-go/repository"
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

type DocumentHandler struct {
	Repository     repository.DocumentRepository
	TripRepository repository.TripRepository
}

// @Summary		Get all documents of a trip
// @Description	Get all documents of a trip
// @Tags			document
// @Accept			json
// @Produce		json
// @Security		BearerAuth
// @Param			id		path		string	true	"ID of the trip"
// @Failure		400		{object}	error
// @Failure		401		{object}	error
// @Router			/trips/{id}/documents [get]
func (handler *DocumentHandler) GetDocumentsOfTrip(context *gin.Context) {
	//

}

// @Summary		Create a new document on trip
// @Description	Create a new document on trip
// @Tags			document
// @Accept			multipart/form-data
// @Produce		json
// @Security		BearerAuth
// @Param			id		path		string	true	"ID of the trip"
// @Param			title		formData	string	true	"Title of the document"
// @Param			description	formData	string	true	"Description of the document"
// @Param			document	formData	file	true	"Document file"
// @Success		200		{object}	responses.DocumentResponse
// @Failure		400		{object}	error
// @Failure		401		{object}	error
// @Router			/trips/{id}/documents [post]
func (handler *DocumentHandler) CreateDocument(context *gin.Context) {
	tripId := context.Param("id")

	title := context.PostForm("title")
	description := context.PostForm("description")

	file, errFile := context.FormFile("document")
	if errFile != nil {
		context.JSON(http.StatusBadRequest, gin.H{"error": "Document is required"})
	}

	// todo save file
	fmt.Println(file)

	trip, _ := handler.TripRepository.Get(tripId)
	var document = models.Document{
		Title:       title,
		Description: description,
		Trip:        trip,
	}

	err := handler.Repository.Create(&document)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	documentResponse := responses.DocumentResponse{
		ID:          document.ID,
		Title:       document.Title,
		Description: document.Description,
		Path:        document.Path,
		CreatedAt:   document.CreatedAt.Format(time.RFC3339),
		UpdateAt:    document.UpdatedAt.Format(time.RFC3339),
	}

	context.JSON(200, documentResponse)
}
