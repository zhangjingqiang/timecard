package configs

import (
	"fmt"
	"os"

	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/postgres"
)

var (
	db       *gorm.DB
	err      error
	host     = "db"
	user     = os.Getenv("DB_USER")
	password = os.Getenv("DB_PASS")
	dbname   = os.Getenv("DB_NAME")
)

func Init() *gorm.DB {
	psqlconn := fmt.Sprintf("host=%s port=5432 user=%s password=%s dbname=%s sslmode=disable", host, user, password, dbname)

	db, err = gorm.Open("postgres", psqlconn)
	if err != nil {
		panic(err)
	}

	return db
}

func Close() {
	if err := db.Close(); err != nil {
		panic(err)
	}
}
