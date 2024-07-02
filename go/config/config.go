package config

import (
	"github.com/go-playground/validator/v10"
	"github.com/spf13/viper"
)

type Config struct {
	DBHost      string `mapstructure:"DB_HOST" validate:"required"`
	DBPort      string `mapstructure:"DB_PORT" validate:"required"`
	DBUser      string `mapstructure:"DB_USER" validate:"required"`
	DBPassword  string `mapstructure:"DB_PASSWORD" validate:"required"`
	DBName      string `mapstructure:"DB_NAME" validate:"required"`
	Mode        string `mapstructure:"MODE" validate:"required"`
	JwtSecret   string `mapstructure:"JWT_SECRET" validate:"required"`
	FrontendURL string `mapstructure:"FRONTEND_URL" validate:"required"`
}

func init() {
	viper.SetConfigFile(".env")
	viper.ReadInConfig()

	viper.BindEnv("DB_HOST")
	viper.SetDefault("DB_HOST", "localhost")
	viper.BindEnv("DB_PORT")
	viper.SetDefault("DB_PORT", "5432")
	viper.BindEnv("DB_USER")
	viper.SetDefault("DB_USER", "challenge_flutter_go")
	viper.BindEnv("DB_NAME")
	viper.SetDefault("DB_NAME", "challenge_flutter_go")
	viper.BindEnv("MODE")
	viper.SetDefault("MODE", "debug")
	viper.BindEnv("DB_PASSWORD")
	viper.BindEnv("JWT_SECRET")
	viper.BindEnv("FRONTEND_URL")
	viper.SetDefault("FRONTEND_URL", "http://localhost:51204")

	// Check if no missing keys in config
	validator := validator.New()
	err := validator.Struct(GetConfig())
	if err != nil {
		panic(err)
	}
}

func GetConfig() (config Config) {
	err := viper.Unmarshal(&config)
	if err != nil {
		panic(err)
	}
	return
}
