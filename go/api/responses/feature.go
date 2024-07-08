package responses

import "challenge-flutter-go/models"

type FeatureResponse struct {
	Name      models.FeatureName `json:"name"`
	IsEnabled bool               `json:"enabled"`
	ModifedBy UserResponse       `json:"modifedBy"`
	UpdateAt  string             `json:"updateAt"`
}
