package requests

type ChatMessageCreateBody struct {
	Content string `json:"content" binding:"required"`
}
