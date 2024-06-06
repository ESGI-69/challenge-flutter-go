package responses

type ChatMessageResponse struct {
	ID        uint         `json:"id"`
	Content   string       `json:"content"`
	Author    UserResponse `json:"author"`
	CreatedAt string       `json:"createdAt"`
}
