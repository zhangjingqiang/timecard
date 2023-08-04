package main

import (
	db "batch/configs"
	"batch/models"
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"log"
	"time"

	amqp "github.com/rabbitmq/amqp091-go"
	"go.mongodb.org/mongo-driver/bson"
)

var ctx = context.Background()

func main() {
	d := db.Init()
	rdb := db.NewRedisClient()
	mongo := db.NewMongoClient()
	es := db.NewESClient()
	mq := db.NewRabbitMQClient()

	// Read from PostgreSQL
	var t []models.Timecard
	if err := d.Find(&t).Error; err != nil {
		panic(err)
	}
	fmt.Println("PostgreSQL data:" + t[0].Date + " " + t[0].Start + " " + t[0].End + " " + t[0].Rest + " " + t[0].Note)

	// Write to Redis
	err := rdb.Set(ctx, "date", t[0].Date, 0).Err()
	if err != nil {
		panic(err)
	}

	resRedis, err := rdb.Get(ctx, "date").Result()
	if err != nil {
		panic(err)
	}
	fmt.Println("Redis inserted data:", resRedis)

	// Write to MongoDB
	collection := mongo.Database("timecard").Collection("timecard")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	resMongo, err := collection.InsertOne(ctx, bson.D{
		{Key: "date", Value: t[0].Date},
		{Key: "start", Value: t[0].Start},
		{Key: "end", Value: t[0].End},
		{Key: "rest", Value: t[0].Rest},
		{Key: "note", Value: t[0].Note},
	})
	if err != nil {
		panic(err)
	}
	fmt.Println("MongoDB inserted id:", resMongo.InsertedID)

	// Write to Elasticsearch
	es.Indices.Create("timecard")
	document := struct {
		Date  string `json:"date"`
		Start string `json:"start"`
		End   string `json:"end"`
		Rest  string `json:"rest"`
		Note  string `json:"note"`
	}{
		t[0].Date,
		t[0].Start,
		t[0].End,
		t[0].Rest,
		t[0].Note,
	}
	data, _ := json.Marshal(document)
	es.Index("timecard", bytes.NewReader(data))

	var r map[string]interface{}
	var buf bytes.Buffer
	query := map[string]interface{}{
		"query": map[string]interface{}{
			"match": map[string]interface{}{
				"note": "good",
			},
		},
	}
	if err := json.NewEncoder(&buf).Encode(query); err != nil {
		log.Fatalf("Error encoding query: %s", err)
	}
	resEs, err := es.Search(
		es.Search.WithContext(context.Background()),
		es.Search.WithIndex("timecard"),
		es.Search.WithBody(&buf),
		es.Search.WithTrackTotalHits(true),
		es.Search.WithPretty(),
	)
	if err != nil {
		panic(err)
	}
	defer resEs.Body.Close()
	if err := json.NewDecoder(resEs.Body).Decode(&r); err != nil {
		log.Fatalf("Error parsing the response body: %s", err)
	}
	fmt.Println("Elasticsearch inserted data:")
	log.Printf(
		"[%s] %d hits; took: %dms",
		resEs.Status(),
		int(r["hits"].(map[string]interface{})["total"].(map[string]interface{})["value"].(float64)),
		int(r["took"].(float64)),
	)
	for _, hit := range r["hits"].(map[string]interface{})["hits"].([]interface{}) {
		log.Printf(" * ID=%s, %s", hit.(map[string]interface{})["_id"], hit.(map[string]interface{})["_source"])
	}

	// Send to RabbitMQ
	channelRabbitMQ, err := mq.Channel()
	if err != nil {
		panic(err)
	}
	defer channelRabbitMQ.Close()

	queue, err := channelRabbitMQ.QueueDeclare(
		"timecard", // queue name
		true,       // durable
		false,      // auto delete
		false,      // exclusive
		false,      // no wait
		nil,        // arguments
	)
	if err == nil {
		fmt.Println("RabbitMQ inserted data:")
		log.Printf("producer: declared queue (%q %d messages, %d consumers), binding to Exchange (key %q)",
			queue.Name, queue.Messages, queue.Consumers, "timecard")
	} else {
		log.Fatalf("producer: Queue Declare: %s", err)
	}

	err = channelRabbitMQ.PublishWithContext(ctx,
		"",         // exchange
		queue.Name, // routing key
		false,      // mandatory
		false,      // immediate
		amqp.Publishing{
			ContentType: "text/plain",
			Body:        []byte(t[0].Date),
		})
	if err != nil {
		log.Fatalf("producer: error in publish: %s", err)
	}

	// Close connection
	mq.Close()
	mongo.Disconnect(context.TODO())
	rdb.Close()
	db.Close()
}
