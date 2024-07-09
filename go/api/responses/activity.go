package responses

type ActivityResponse struct {
	ID          uint         `json:"id"`
	Name        string       `json:"name"`
	Description string       `json:"description"`
	Price       float64      `json:"price"`
	Location    string       `json:"location"`
	Latitude    float64      `json:"latitude"`
	Longitude   float64      `json:"longitude"`
	Owner       UserResponse `json:"owner"`
}
