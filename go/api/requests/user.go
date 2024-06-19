package requests

type UserCreateBody struct {
	Username string `json:"username" binding:"required" validate:"not_trimmed_empty"`
	Password string `json:"password" binding:"required" validate:"min=8,max=64,not_trimmed_empty"`
}
