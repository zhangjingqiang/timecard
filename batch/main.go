package main

import (
	db "batch/configs"
	"batch/models"
	"context"
	"fmt"
)

var ctx = context.Background()

func main() {
	d := db.Init()
	rdb := db.NewRedisClient()

	var t []models.Timecard
	if err := d.Find(&t).Error; err != nil {
		panic(err)
	}
	fmt.Println(t[0].Date + " " + t[0].Start + " " + t[0].End + " " + t[0].Rest + " " + t[0].Note)

	// Write to Redis
	err := rdb.Set(ctx, "note", t[0].Note, 0).Err()
	if err != nil {
		panic(err)
	}

	val, err := rdb.Get(ctx, "note").Result()
	if err != nil {
		panic(err)
	}
	fmt.Println("key", val)

	db.Close()
}
