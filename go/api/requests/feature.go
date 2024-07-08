package requests

type FeatureCreateBody struct {
	Name string `json:"name" validate:"max=64"`
}

type FeatureUpdateBody struct {
	Enabled bool `json:"enabled"`
}
