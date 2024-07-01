package utils

import (
	"strings"

	"github.com/go-playground/validator/v10"
)

func SpaceTrimmedEmpty(fl validator.FieldLevel) bool {
	return strings.ReplaceAll(fl.Field().String(), " ", "") != ""
}
