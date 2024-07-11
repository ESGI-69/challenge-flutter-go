package responses

import "challenge-flutter-go/models"

type TransportResponse struct {
	ID               uint                 `json:"id"`
	TransportType    models.TransportType `json:"transportType"`
	StartDate        string               `json:"startDate"`
	EndDate          string               `json:"endDate"`
	StartAddress     string               `json:"startAddress"`
	StartLatitude    float64              `json:"startLatitude"`
	StartLongitude   float64              `json:"startLongitude"`
	EndAddress       string               `json:"endAddress"`
	EndLatitude      float64              `json:"endLatitude"`
	EndLongitude     float64              `json:"endLongitude"`
	MeetingAddress   string               `json:"meetingAddress"`
	MeetingLatitude  float64              `json:"meetingLatitude"`
	MeetingLongitude float64              `json:"meetingLongitude"`
	MeetingTime      string               `json:"meetingTime"`
	Author           UserResponse         `json:"author"`
	Price            float64              `json:"price"`
}
