package requests

import "mime/multipart"

type DocumentCreateBody struct {
	Title       string                `json:"title" binding:"required"`
	Description string                `json:"description" binding:"required"`
	Document    *multipart.FileHeader `form:"document" binding:"required"`
}
