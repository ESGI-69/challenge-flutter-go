package requests

type ChatMessageCreateBody struct {
	Content string `json:"Content" binding:"required"`
}
