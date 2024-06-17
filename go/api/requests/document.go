package requests

import "mime/multipart"

type DocumentCreateBody struct {
	Title       string                `json:"title" binding:"required"`
	Description string                `json:"description"`
	Document    *multipart.FileHeader `form:"document" binding:"required"`
}
