package responses

type PhotoResponse struct {
	ID          uint         `json:"id"`
	Title       string       `json:"title"`
	Description string       `json:"description"`
	CreatedAt   string       `json:"createdAt"`
	UpdateAt    string       `json:"updateAt"`
	Owner       UserResponse `json:"owner"`
}
