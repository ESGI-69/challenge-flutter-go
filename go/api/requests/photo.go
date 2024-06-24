package requests

import "mime/multipart"

type PhotoCreateBody struct {
	Title       string                `json:"title" binding:"required"`
	Description string                `json:"description"`
	Photo       *multipart.FileHeader `form:"photo" binding:"required"`
}
