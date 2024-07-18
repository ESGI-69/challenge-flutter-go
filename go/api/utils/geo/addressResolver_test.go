package geo

import (
	"testing"
)

func TestGetGeoLocationRealURL(t *testing.T) {
	var lat, lon float64
	err := GetGeoLocation("Paris", &lat, &lon)
	if err != nil {
		t.Fatalf("GetGeoLocation à return une error : %v", err)
	}

	//On check si les coordonnées de paris sont correcte
	expectedLat, expectedLon := 48.8566, 2.3522
	if lat < expectedLat-0.05 || lat > expectedLat+0.05 || lon < expectedLon-0.05 || lon > expectedLon+0.05 {
		t.Errorf("Attendu ~ (%v, %v), obtenu (%v, %v)", expectedLat, expectedLon, lat, lon)
	}
}

func TestGetGeoLocationInvalidInput(t *testing.T) {
	//should return 0 0 if the address is invalid
	var lat, lon float64
	err := GetGeoLocation("", &lat, &lon)
	if err != nil {
		t.Fatalf("GetGeoLocation à return une error : %v", err)
	}
	if lat != 0 || lon != 0 {
		t.Errorf("Attendu (0, 0), on a (%v, %v)", lat, lon)
	}
}
