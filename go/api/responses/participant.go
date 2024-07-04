package responses

type TripParticipantsResponse struct {
	Participants []ParticipantResponse `json:"participants"`
}
