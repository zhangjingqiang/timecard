package configs

import (
	"os"

	"github.com/elastic/go-elasticsearch/v8"
)

func NewESClient() *elasticsearch.Client {
	cfg := elasticsearch.Config{
		Addresses: []string{
			"http://" + os.Getenv("ELASTICSEARCH_ADDR"),
		},
		Username: os.Getenv("ELASTICSEARCH_USER"),
		Password: os.Getenv("ELASTICSEARCH_PASS"),
	}
	es, err := elasticsearch.NewClient(cfg)
	if err != nil {
		panic(err)
	}

	return es
}
