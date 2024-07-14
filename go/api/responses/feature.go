package responses

import "challenge-flutter-go/models"

type FeatureResponse struct {
	Name       models.FeatureName `json:"name"`
	IsEnabled  bool               `json:"isEnabled"`
	ModifiedBy UserRoleReponse    `json:"modifiedBy"`
	UpdatedAt  string             `json:"updatedAt"`
}
