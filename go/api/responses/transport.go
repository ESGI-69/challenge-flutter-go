package responses

import "challenge-flutter-go/models"

type TransportResponse struct {
	ID            uint                 `json:"id"`
	TransportType models.TransportType `json:"transportType"`
	StartDate     string               `json:"startDate"`
	EndDate       string               `json:"endDate"`
	StartAddress  string               `json:"startAddress"`
	EndAddress    string               `json:"endAddress"`
}
