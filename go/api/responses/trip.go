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

type TripAddTransport struct {
	TransportType string       `json:"transportType"`
	StartDate     string       `json:"startDate"`
	TripID        uint         `json:"tripId"`
	Trip          TripResponse `json:"trip"`
	EndDate       string       `json:"endDate"`
	StartAddress  string       `json:"startAddress"`
	EndAddress    string       `json:"endAddress"`
}
