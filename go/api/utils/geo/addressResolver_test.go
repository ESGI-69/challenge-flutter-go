package geo

import (
	"testing"

	"github.com/jarcoal/httpmock"
)

func TestGetGeoLocationRealURL(t *testing.T) {
	httpmock.Activate()
	defer httpmock.DeactivateAndReset()

	httpmock.RegisterResponder("GET", "https://nominatim.openstreetmap.org/search?q=Paris&format=json",
		httpmock.NewStringResponder(200, `[{"lat":"48.8566","lon":"2.3522"}]`))

	var lat, lon float64
	err := GetGeoLocation("Paris", &lat, &lon)
	if err != nil {
		t.Fatalf("GetGeoLocation a return une error: %v", err)
	}

	// Check si les cords de paris sont bonnes
	expectedLat, expectedLon := 48.8566, 2.3522
	if lat < expectedLat-0.01 || lat > expectedLat+0.01 || lon < expectedLon-0.01 || lon > expectedLon+0.01 {
		t.Errorf("Expected ~ (%v, %v), got (%v, %v)", expectedLat, expectedLon, lat, lon)
	}
}

func TestGetGeoLocationInvalidInput(t *testing.T) {
	httpmock.Activate()
	defer httpmock.DeactivateAndReset()

	// Mock response for invalid input
	httpmock.RegisterResponder("GET", "https://nominatim.openstreetmap.org/search?q=&format=json",
		httpmock.NewStringResponder(200, `[]`))

	var lat, lon float64
	err := GetGeoLocation("", &lat, &lon)
	if err != nil {
		t.Fatalf("GetGeoLocation a return une error: %v", err)
	}
	if lat != 0 || lon != 0 {
		t.Errorf("Expected (0, 0), got (%v, %v)", lat, lon)
	}
}
