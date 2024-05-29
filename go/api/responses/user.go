package responses

type UserResponse struct {
	ID       uint   `json:"id"`
	Username string `json:"username"`
	Role     string `json:"role"`
}

type UserInfoResponse struct {
	ID       uint           `json:"id"`
	Username string         `json:"username"`
	Role     string         `json:"role"`
	Trips    []TripResponse `json:"trips"`
}
