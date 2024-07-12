package responses

type DocumentResponse struct {
	ID          uint         `json:"id"`
	Title       string       `json:"title"`
	Description string       `json:"description"`
	Path        string       `json:"path"`
	CreatedAt   string       `json:"createdAt"`
	UpdateAt    string       `json:"updateAt"`
	Owner       UserResponse `json:"owner"`
}
