package utils

import (
	"fmt"
	"io"
	"math/rand"
	"mime/multipart"
	"os"
	"path/filepath"
	"time"
)

func SaveUploadedFile(file *multipart.FileHeader, fileType, userTitle string) (string, error) {
	baseDir := "uploads"

	var specificDir string
	switch fileType {
	case "document":
		specificDir = filepath.Join(baseDir, "documents")
	case "photo":
		specificDir = filepath.Join(baseDir, "photos")
	case "profile-picture":
		specificDir = filepath.Join(baseDir, "profile-pictures")
	default:
		return "", fmt.Errorf("unsupported file type")
	}

	err := os.MkdirAll(specificDir, os.ModePerm)
	if err != nil {
		return "", err
	}

	src, err := file.Open()
	if err != nil {
		return "", err
	}
	defer src.Close()

	rand.Seed(time.Now().UnixNano())
	randomNumber := rand.Intn(90000000) + 10000000

	uniqueTitle := fmt.Sprintf("%s-%d", userTitle, randomNumber)

	ext := filepath.Ext(file.Filename)
	newFileName := uniqueTitle + ext

	filePath := filepath.Join(specificDir, newFileName)

	dst, err := os.Create(filePath)
	if err != nil {
		return "", err
	}
	defer dst.Close()

	if _, err := io.Copy(dst, src); err != nil {
		return "", err
	}

	return newFileName, nil
}

func GetFilePath(fileType, fileName string) (string, error) {
	baseDir := "uploads"

	var specificDir string
	switch fileType {
	case "document":
		specificDir = filepath.Join(baseDir, "documents")
	case "photo":
		specificDir = filepath.Join(baseDir, "photos")
	case "banner":
		specificDir = filepath.Join("banner")
	case "profile-picture":
		specificDir = filepath.Join(baseDir, "profile-pictures")
	default:
		return "", fmt.Errorf("unsupported file type")
	}

	filePath := filepath.Join(specificDir, fileName)

	return filePath, nil
}

func DeleteFile(fileType, fileName string) error {
	baseDir := "uploads"

	var specificDir string
	switch fileType {
	case "document":
		specificDir = filepath.Join(baseDir, "documents")
	case "photo":
		specificDir = filepath.Join(baseDir, "photos")
	case "profile-picture":
		specificDir = filepath.Join(baseDir, "profile-pictures")
	default:
		return fmt.Errorf("unsupported file type")
	}

	filePath := filepath.Join(specificDir, fileName)

	err := os.Remove(filePath)
	if err != nil {
		return err
	}

	fmt.Println("File deleted: " + filePath)
	return nil
}
