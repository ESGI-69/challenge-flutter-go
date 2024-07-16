package responses

type TripResponse struct {
	ID           uint                  `json:"id"`
	Name         string                `json:"name"`
	Country      string                `json:"country"`
	City         string                `json:"city"`
	StartDate    string                `json:"startDate"`
	EndDate      string                `json:"endDate"`
	Participants []ParticipantResponse `json:"participants"`
	InviteCode   string                `json:"inviteCode"`
	TotalPrice   float64               `json:"totalPrice"`
	CreatedAt    string                `json:"createdAt"`
	UpdatedAt    string                `json:"updatedAt"`
	Owner        UserResponse          `json:"owner"`
	Latitude     float64               `json:"latitude"`
	Longitude    float64               `json:"longitude"`
}
