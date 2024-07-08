package handlers

import (
	"challenge-flutter-go/api/errorHandlers"
	"challenge-flutter-go/api/requests"
	"challenge-flutter-go/api/responses"
	"challenge-flutter-go/api/utils"
	"challenge-flutter-go/logger"
	"challenge-flutter-go/repository"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

type FeatureHandler struct {
	Repository repository.FeatureRepository
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
// @Router /admin/app-settings/{id} [patch]
func (handler *FeatureHandler) Update(context *gin.Context) {
	featureId := context.Param("id")

	var requestBody requests.FeatureUpdateBody
	isBodyValid := utils.Deserialize(&requestBody, context)
	if !isBodyValid {
		return
	}

	feature, _ := handler.Repository.Get(featureId)
	currentUser, _ := utils.GetCurrentUser(context)

	feature.IsEnabled = requestBody.IsEnabled
	feature.ModifiedBy = currentUser

	updateError := handler.Repository.Update(&feature)
	if updateError != nil {
		errorHandlers.HandleGormErrors(updateError, context)
		return
	}

	responseFeature := responses.FeatureResponse{
		Name:      feature.Name,
		IsEnabled: feature.IsEnabled,
		ModifedBy: responses.UserResponse{
			ID:       feature.ModifiedBy.ID,
			Username: feature.ModifiedBy.Username,
		},
		UpdateAt: feature.UpdatedAt.Format(time.RFC3339),
	}

	context.JSON(http.StatusOK, responseFeature)
	logger.ApiInfo(context, "Feature "+featureId+" updated")
}

// Get all features as Admin
//
//	@Summary		Get all features
//	@Description	Get all features as Admin
//	@Tags			features
//	@Accept			json
//	@Produce		json
//	@Security		BearerAuth
//	@Success		200	{array}		responses.FeatureResponse
//	@Failure		400	{object}	error
//	@Failure		401	{object}	error
//	@Router			/app-settings [get]
func (handler *FeatureHandler) GetFeatures(context *gin.Context) {
	features, err := handler.Repository.GetFeatures()
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	responseFeatures := make([]responses.FeatureResponse, len(features))
	for i, feature := range features {
		responseFeatures[i] = responses.FeatureResponse{
			Name: feature.Name,
			ModifedBy: responses.UserResponse{
				ID:       feature.ModifiedBy.ID,
				Username: feature.ModifiedBy.Username,
			},
			IsEnabled: feature.IsEnabled,
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
//	@Router			/admin/app-settings [get]
func (handler *FeatureHandler) GetFeaturesAdmin(context *gin.Context) {
	features, err := handler.Repository.GetFeatures()
	if err != nil {
		errorHandlers.HandleGormErrors(err, context)
		return
	}

	responseFeatures := make([]responses.FeatureResponse, len(features))
	for i, feature := range features {
		responseFeatures[i] = responses.FeatureResponse{
			Name: feature.Name,
			ModifedBy: responses.UserResponse{
				ID:       feature.ModifiedBy.ID,
				Username: feature.ModifiedBy.Username,
			},
			IsEnabled: feature.IsEnabled,
			UpdateAt:  feature.UpdatedAt.Format(time.RFC3339),
		}
	}

	context.JSON(http.StatusOK, responseFeatures)
	logger.ApiInfo(context, "Get all features")
}
