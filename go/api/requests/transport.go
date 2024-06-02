package requests

type TransportCreateBody struct {
	StartDate     string `json:"StartDate" binding:"required"`
	EndDate       string `json:"EndDate" binding:"required"`
	TransportType string `json:"TransportType" binding:"required"`
	StartAddress  string `json:"StartAddress" binding:"required"`
	EndAddress    string `json:"EndAddress" binding:"required"`
}
