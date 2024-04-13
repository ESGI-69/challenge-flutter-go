package main

import (
	"esgi69/challenge-flutter-go/config"
	"fmt"
)

func main() {
	fmt.Print(config.GetConfig().DBHost)
}
