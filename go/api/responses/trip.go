package responses

type TripResponse struct {
	ID           uint           `json:"id"`
	Name         string         `json:"name"`
	Country      string         `json:"country"`
	City         string         `json:"city"`
	StartDate    string         `json:"startDate"`
	EndDate      string         `json:"endDate"`
	Owner        UserResponse   `json:"owner"`
	Participants []UserResponse `json:"participants"`
}
