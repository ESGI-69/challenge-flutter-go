package requests

type NoteCreateBody struct {
	Title   string `json:"title" binding:"required"`
	Content string `json:"content" binding:"required"`
}
