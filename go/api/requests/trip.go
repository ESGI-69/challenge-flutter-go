package requests

type TripCreateBody struct {
	Name      string `json:"name" binding:"required"`
	Country   string `json:"country" binding:"required"`
	City      string `json:"city" binding:"required"`
	StartDate string `json:"startDate" binding:"required"`
	EndDate   string `json:"endDate" binding:"required"`
}

type TripUpdateBody struct {
	Name      string `json:"name"`
	Country   string `json:"country"`
	City      string `json:"city"`
	StartDate string `json:"startDate"`
	EndDate   string `json:"endDate"`
}

type TripAddTransportBody struct {
	StartDate     string `json:"StartDate" binding:"required"`
	EndDate       string `json:"EndDate" binding:"required"`
	TransportType string `json:"TransportType" binding:"required"`
	StartAddress  string `json:"StartAddress" binding:"required"`
	EndAddress    string `json:"EndAddress" binding:"required"`
}
