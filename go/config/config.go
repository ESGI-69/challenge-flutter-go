package config

import (
	"github.com/spf13/viper"
)

type Config struct {
	DBHost     string `mapstructure:"DB_HOST"`
	DBPort     string `mapstructure:"DB_PORT"`
	DBUser     string `mapstructure:"DB_USER"`
	DBPassword string `mapstructure:"DB_PASSWORD"`
	DBName     string `mapstructure:"DB_NAME"`
}

func init() {
	viper.SetConfigFile(".env")
	viper.ReadInConfig()
	viper.AutomaticEnv()

	viper.SetDefault("DB_HOST", "localhost")
	viper.SetDefault("DB_PORT", "5432")
	viper.SetDefault("DB_USER", "challenge_flutter_go")
	viper.SetDefault("DB_PASSWORD", "challenge_flutter_go")
	viper.SetDefault("DB_NAME", "challenge_flutter_go")
}

func GetConfig() (config Config) {
	err := viper.Unmarshal(&config)
	if err != nil {
		panic(err)
	}
	return
}
