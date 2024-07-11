package responses

import "challenge-flutter-go/models"

type AccommodationResponse struct {
	ID                uint                     `json:"id"`
	AccommodationType models.AccommodationType `json:"accommodationType"`
	Name              string                   `json:"name"`
	StartDate         string                   `json:"startDate"`
	EndDate           string                   `json:"endDate"`
	Address           string                   `json:"address"`
	BookingURL        string                   `json:"bookingURL"`
	Latitude          float64                  `json:"latitude"`
	Longitude         float64                  `json:"longitude"`
	Price             float64                  `json:"price"`
}
