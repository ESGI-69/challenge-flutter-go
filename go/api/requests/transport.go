package requests

type TransportCreateBody struct {
	StartDate      string  `json:"startDate" binding:"required"`
	EndDate        string  `json:"endDate" binding:"required"`
	TransportType  string  `json:"transportType" binding:"required"`
	StartAddress   string  `json:"startAddress" binding:"required"`
	EndAddress     string  `json:"endAddress" binding:"required"`
	MeetingAddress string  `json:"meetingAddress"`
	MeetingTime    string  `json:"meetingTime"`
	Price          float64 `json:"price" binding:"required"`
}
