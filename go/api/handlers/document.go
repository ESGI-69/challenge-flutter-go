package handlers

import (
	"challenge-flutter-go/api/errorHandlers"
	"challenge-flutter-go/api/responses"
	"challenge-flutter-go/api/utils"
	"challenge-flutter-go/logger"
	"challenge-flutter-go/models"
	"challenge-flutter-go/repository"
	"net/http"
	"strconv"
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
	tripId := context.Param("id")

	documents, err := handler.Repository.GetDocuments(tripId)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	documentResponses := make([]responses.DocumentResponse, len(documents))
	for i, document := range documents {
		documentResponses[i] = responses.DocumentResponse{
			ID:          document.ID,
			Title:       document.Title,
			Description: document.Description,
			Path:        document.Path,
			CreatedAt:   document.CreatedAt.Format(time.RFC3339),
			UpdateAt:    document.UpdatedAt.Format(time.RFC3339),
		}
	}
	context.JSON(http.StatusOK, documentResponses)
	logger.ApiInfo(context, "Get all documents from trip "+tripId)
}

// @Summary		Create a new document on trip
// @Description	Create a new document on trip
// @Tags			document
// @Accept			multipart/form-data
// @Produce		json
// @Security		BearerAuth
// @Param			id		path		string	true	"ID of the trip"
// @Param			title		formData	string	true	"Title of the document"
// @Param			description	formData	string	false	"Description of the document"
// @Param			document	formData	file	true	"Document file"
// @Success		200		{object}	responses.DocumentResponse
// @Failure		400		{object}	error
// @Failure		401		{object}	error
// @Router			/trips/{id}/documents [post]
func (handler *DocumentHandler) CreateDocument(context *gin.Context) {
	context.Request.Body = http.MaxBytesReader(context.Writer, context.Request.Body, 10<<20)

	tripIdStr := context.Param("id")
	tripId, _ := strconv.ParseUint(tripIdStr, 10, 32)

	title := context.PostForm("title")
	description := context.PostForm("description")

	file, errFile := context.FormFile("document")
	if errFile != nil {
		logger.ApiWarning(context, "Document is missing on request")
		context.JSON(http.StatusBadRequest, gin.H{"error": "Document is missing on request"})
	}

	if file.Size > 5<<20 {
		logger.ApiWarning(context, "File size exceeds limit of 5 MB")
		context.JSON(http.StatusBadRequest, gin.H{"error": "File size exceeds limit of 5 MB"})
		return
	}

	filePath, errFilePath := utils.SaveUploadedFile(file, "document", title)
	if errFilePath != nil {
		logger.ApiError(context, "Error saving file: "+filePath)
		context.JSON(http.StatusInternalServerError, gin.H{"error": "Error saving file"})
		return
	}

	var document = models.Document{
		Title:       title,
		Description: description,
		TripID:      uint(tripId),
		Path:        filePath,
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
	logger.ApiInfo(context, "Create a document "+document.Path+" on trip "+tripIdStr)
}

// @Summary      Download a document
// @Description  Download a document
// @Tags         document
// @Accept       json
// @Produce      application/octet-stream
// @Security     BearerAuth
// @Param        id          path      string  true  "ID of the trip"
// @Param        documentID  path      string  true  "ID of the document"
// @Success      200         {file}    true    "A file stream of the document"
// @Failure      400         {object}  error
// @Failure      401         {object}  error
// @Failure      404         {object}  error
// @Router       /trips/{id}/documents/{documentID}/download [get]
func (handler *DocumentHandler) DownloadDocument(context *gin.Context) {
	documentID := context.Param("documentID")

	document, errDoc := handler.Repository.Get(documentID)
	if errDoc != nil {
		errorHandlers.HandleGormErrors(errDoc, context)
		return
	}

	filepath, errFilePath := utils.GetFilePath("document", document.Path)
	if errFilePath != nil {
		logger.ApiError(context, "Failed to get file path "+document.Path)
		context.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get file path"})
		return
	}
	context.Header("Content-Disposition", "attachment; filename=\""+document.Path+"\"")
	context.File(filepath)
	logger.ApiInfo(context, "Download a document "+document.Path)
}

// @Summary		Delete a document from trip
// @Description	Delete a document from the trip
// @Tags			document
// @Accept			json
// @Produce		json
// @Security		BearerAuth
// @Param			id			path		string	true	"ID of the trip"
// @Param			documentID	path		string	true	"ID of the document"
// @Success		204			{object}	error
// @Failure		400			{object}	error
// @Failure		401			{object}	error
// @Failure		404			{object}	error
// @Router			/trips/{id}/documents/{documentID} [delete]
func (handler *DocumentHandler) DeleteDocumentFromTrip(context *gin.Context) {
	documentID := context.Param("documentID")
	if documentID == "" {
		logger.ApiWarning(context, "No document ID provided")
		context.AbortWithStatus(http.StatusBadRequest)
		return
	}
	err := handler.Repository.DeleteDocument(documentID)
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	context.JSON(http.StatusNoContent, gin.H{})
	logger.ApiInfo(context, "Delete a document "+documentID)
}
