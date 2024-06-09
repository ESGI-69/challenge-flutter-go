package requests

type AccommodationCreateBody struct {
	AccommodationType string `json:"accommodationType" binding:"required"`
	Name              string `json:"name" binding:"required"`
	StartDate         string `json:"startDate" binding:"required"`
	EndDate           string `json:"endDate" binding:"required"`
	Address           string `json:"address" binding:"required"`
	BookingURL        string `json:"bookingURL"`
}
