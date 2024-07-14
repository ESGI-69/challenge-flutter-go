package requests

import "challenge-flutter-go/models"

type UserCreateBody struct {
	Username string `json:"username" binding:"required" validate:"space_trimmed_empty"`
	Password string `json:"password" binding:"required" validate:"min=8,max=64,space_trimmed_empty"`
}

type UserUpdateBody struct {
	Password string `json:"password" binding:"required" validate:"min=8,max=64,space_trimmed_empty"`
}

type UserChangeRoleBody struct {
	Role models.UserRole `json:"role" binding:"required"`
}
