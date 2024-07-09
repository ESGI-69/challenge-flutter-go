package requests

type ActivityCreateBody struct {
	Name        string  `json:"name" binding:"required"`
	Description string  `json:"description"`
	Price       float64 `json:"price" binding:"required"`
	Location    string  `json:"location"`
}
