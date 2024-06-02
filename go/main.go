package main

import (
	"challenge-flutter-go/api"
)

// @title						Challenge Flutter Go API
// @description				This is the API for the Challenge Flutter Go project
// @termsOfService				https://challenge-flutter-go.com/terms
// @contact.name				Challenge Flutter Go
// @contact.url				https://challenge-flutter-go.com
// @license.name				Apache 2.0
// @license.url				http://www.apache.org/licenses/LICENSE-2.0.html
// @securityDefinitions.apikey	BearerAuth
// @in							header
// @name						Authorization
// @externalDocs.description	OpenAPI
// @externalDocs.url			https://swagger.io/resources/open-api/
func main() {
	api.Start()
}
