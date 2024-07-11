package responses

import "challenge-flutter-go/models"

type FeatureResponse struct {
	Name       models.FeatureName `json:"name"`
	IsEnabled  bool               `json:"isEnabled"`
	ModifiedBy UserResponse       `json:"modifiedBy"`
	UpdateAt   string             `json:"updateAt"`
}
