package requests

type NoteCreateBody struct {
	Title   string `json:"Title" binding:"required"`
	Content string `json:"Content" binding:"required"`
}
