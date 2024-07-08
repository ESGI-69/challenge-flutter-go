package responses

type FeatureResponse struct {
	ID        uint         `json:"id"`
	Name      string       `json:"name"`
	Enabled   bool         `json:"enabled"`
	ModifedBy UserResponse `json:"modifedBy"`
	CreatedAt string       `json:"createdAt"`
	UpdateAt  string       `json:"updateAt"`
}
