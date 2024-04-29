package config

import (
	"github.com/go-playground/validator/v10"
	"github.com/spf13/viper"
)

type Config struct {
	DBHost     string `mapstructure:"DB_HOST" validate:"required"`
	DBPort     string `mapstructure:"DB_PORT" validate:"required"`
	DBUser     string `mapstructure:"DB_USER" validate:"required"`
	DBPassword string `mapstructure:"DB_PASSWORD" validate:"required"`
	DBName     string `mapstructure:"DB_NAME" validate:"required"`
	Mode       string `mapstructure:"MODE" validate:"required"`
	JwtSecret  string `mapstructure:"JWT_SECRET" validate:"required"`
}

func init() {
	viper.SetConfigFile(".env")
	viper.ReadInConfig()
	viper.AutomaticEnv()

	viper.SetDefault("DB_HOST", "localhost")
	viper.SetDefault("DB_PORT", "5432")
	viper.SetDefault("DB_USER", "challenge_flutter_go")
	viper.SetDefault("DB_NAME", "challenge_flutter_go")
	viper.SetDefault("MODE", "debug")

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
