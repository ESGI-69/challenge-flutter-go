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

type FeatureHandler struct {
	Repository repository.FeatureRepository
}

// Create a new feature
//
//	@Summary		Create a new feature
//	@Description	Create a new feature
//	@Tags			admin
//	@Accept			json
//	@Produce		json
//	@Security		BearerAuth
//	@Param			body	body		requests.FeatureCreateBody	true	"Body of the feature"
//	@Success		201		{object}	responses.FeatureResponse
//	@Failure		400		{object}	error
//	@Failure		401		{object}	error
//	@Router			/admin/features [post]
func (handler *FeatureHandler) Create(context *gin.Context) {
	var requestBody requests.FeatureCreateBody
	isBodyValid := utils.Deserialize(&requestBody, context)
	if !isBodyValid {
		return
	}

	currentUser, _ := utils.GetCurrentUser(context)

	feature := models.Feature{
		Name:       requestBody.Name,
		ModifiedBy: currentUser,
		Enabled:    false,
	}

	err := handler.Repository.Create(&feature)

	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	responseFeature := responses.FeatureResponse{
		ID:      feature.ID,
		Name:    feature.Name,
		Enabled: feature.Enabled,
		ModifedBy: responses.UserResponse{
			ID:       feature.ModifiedBy.ID,
			Username: feature.ModifiedBy.Username,
		},
		CreatedAt: feature.CreatedAt.Format(time.RFC3339),
		UpdateAt:  feature.UpdatedAt.Format(time.RFC3339),
	}

	context.JSON(http.StatusCreated, responseFeature)
	logger.ApiInfo(context, "Feature "+string(rune(feature.ID))+" created")
}

// @Summary Update a feature
// @Description Update a feature if the current is admin
// @Tags admin
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "ID of the feature"
// @Param body body requests.FeatureUpdateBody true "Body of the feature"
// @Success 200 {object} responses.FeatureResponse
// @Failure 400 {object} error
// @Failure 401 {object} error
// @Failure 404 {object} error
// @Router /admin/features/{id} [patch]
func (handler *FeatureHandler) Update(context *gin.Context) {
	featureId := context.Param("id")

	var requestBody requests.FeatureUpdateBody
	isBodyValid := utils.Deserialize(&requestBody, context)
	if !isBodyValid {
		return
	}

	feature, _ := handler.Repository.Get(featureId)
	currentUser, _ := utils.GetCurrentUser(context)

	feature.Enabled = requestBody.Enabled
	feature.ModifiedBy = currentUser

	updateError := handler.Repository.Update(&feature)
	if updateError != nil {
		errorHandlers.HandleGormErrors(updateError, context)
		return
	}

	responseFeature := responses.FeatureResponse{
		ID:      feature.ID,
		Name:    feature.Name,
		Enabled: feature.Enabled,
		ModifedBy: responses.UserResponse{
			ID:       feature.ModifiedBy.ID,
			Username: feature.ModifiedBy.Username,
		},
		CreatedAt: feature.CreatedAt.Format(time.RFC3339),
		UpdateAt:  feature.UpdatedAt.Format(time.RFC3339),
	}

	context.JSON(http.StatusOK, responseFeature)
	logger.ApiInfo(context, "Feature "+featureId+" updated")
}

// @Summary Delete a feature
// @Description Delete a feature if the user is admin
// @Tags admin
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "ID of the feature"
// @Success 204
// @Failure 400 {object} error
// @Failure 401 {object} error
// @Router /admin/features/{id} [delete]
func (handler *FeatureHandler) Delete(context *gin.Context) {
	featureId := context.Param("id")

	deleteError := handler.Repository.Delete(featureId)
	if deleteError != nil {
		errorHandlers.HandleGormErrors(deleteError, context)
		return
	}

	context.Status(http.StatusNoContent)
	logger.ApiInfo(context, "Delete feature "+featureId)
}

// Get all features
//
//	@Summary		Get all features
//	@Description	Get all features
//	@Tags			features
//	@Accept			json
//	@Produce		json
//	@Security		BearerAuth
//	@Success		200	{array}		responses.FeatureResponse
//	@Failure		400	{object}	error
//	@Failure		401	{object}	error
//	@Router			/features [get]
func (handler *FeatureHandler) GetFeatures(context *gin.Context) {
	features, err := handler.Repository.GetFeatures()
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	responseFeatures := make([]responses.FeatureResponse, len(features))
	for i, feature := range features {
		responseFeatures[i] = responses.FeatureResponse{
			ID:   feature.ID,
			Name: feature.Name,
			ModifedBy: responses.UserResponse{
				ID:       feature.ModifiedBy.ID,
				Username: feature.ModifiedBy.Username,
			},
			Enabled:   feature.Enabled,
			CreatedAt: feature.CreatedAt.Format(time.RFC3339),
			UpdateAt:  feature.UpdatedAt.Format(time.RFC3339),
		}
	}

	context.JSON(http.StatusOK, responseFeatures)
	logger.ApiInfo(context, "Get all features")
}

// Get all features as Admin
//
//	@Summary		Get all features
//	@Description	Get all features as Admin
//	@Tags			admin
//	@Accept			json
//	@Produce		json
//	@Security		BearerAuth
//	@Success		200	{array}		responses.FeatureResponse
//	@Failure		400	{object}	error
//	@Failure		401	{object}	error
//	@Router			/admin/features [get]
func (handler *FeatureHandler) GetFeaturesAdmin(context *gin.Context) {
	features, err := handler.Repository.GetFeatures()
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	responseFeatures := make([]responses.FeatureResponse, len(features))
	for i, feature := range features {
		responseFeatures[i] = responses.FeatureResponse{
			ID:   feature.ID,
			Name: feature.Name,
			ModifedBy: responses.UserResponse{
				ID:       feature.ModifiedBy.ID,
				Username: feature.ModifiedBy.Username,
			},
			Enabled:   feature.Enabled,
			CreatedAt: feature.CreatedAt.Format(time.RFC3339),
			UpdateAt:  feature.UpdatedAt.Format(time.RFC3339),
		}
	}

	context.JSON(http.StatusOK, responseFeatures)
	logger.ApiInfo(context, "Get all features")
}
