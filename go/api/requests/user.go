package requests

type UserCreateBody struct {
	Username string `json:"username" binding:"required" validate:"space_trimmed_empty"`
	Password string `json:"password" binding:"required" validate:"min=8,max=64,space_trimmed_empty"`
}

type UserChangeRoleBody struct {
	Role string `json:"role" binding:"required" validate:"oneof=ADMIN USER"`
}
