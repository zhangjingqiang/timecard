package configs

import (
	"os"

	amqp "github.com/rabbitmq/amqp091-go"
)

func NewRabbitMQClient() *amqp.Connection {
	amqpServerURL := "amqp://" + os.Getenv("RABBITMQ_USER") + ":" + os.Getenv("RABBITMQ_PASS") + "@" + os.Getenv("RABBITMQ_ADDR") + "/"

	connectRabbitMQ, err := amqp.Dial(amqpServerURL)
	if err != nil {
		panic(err)
	}

	return connectRabbitMQ
}
