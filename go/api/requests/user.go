package requests

type UserCreateBody struct {
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required" validate:"min=8,max=64"`
}
