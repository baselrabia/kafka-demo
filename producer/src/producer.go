package main

import (
	"encoding/json"
	"fmt"
	"log"
	"math/rand"
	"os"
	"time"

	"github.com/Shopify/sarama"
)

var (
	kafkaHost = os.Getenv("KAFKA_HOST")
	topic     = os.Getenv("TOPIC")
	user      = os.Getenv("USER")
)

type KMsg struct {
	ID   int    `json:"ID"`
	Name string `json:"Name"`
}

func main() {
	// Get the environment variable
	fmt.Printf("ENV: running kafka on %s ,The value of Topic is: %s\n", kafkaHost, topic)

	config := sarama.NewConfig()
	config.Producer.Return.Successes = true
	config.Metadata.AllowAutoTopicCreation = false

	var conn sarama.SyncProducer
	var err error
	hasConn := false
	for !hasConn {
		conn, err = sarama.NewSyncProducer([]string{kafkaHost}, config)
		if err != nil {
			log.Print("Could not connect to Kafka (will try after 5 sec): ", err)
			time.Sleep(time.Second * 5)
		} else {
			hasConn = true
		}
	}

	defer conn.Close()


	i := 0
	for {
		kmsg, _ := json.Marshal(&KMsg{ID: i, Name: user})

		msg := &sarama.ProducerMessage{
			Topic: topic,
			Key:   sarama.StringEncoder(fmt.Sprint(i)),
			Value: sarama.StringEncoder(kmsg),
			// Value: sarama.StringEncoder(fmt.Sprintf("{ ID: %v, Name: %s }", i, user)),
		}

		// Generate a random number between 0 and 99
		r := rand.Intn(100)

		// 10% chance of not writing the message to Kafka
		if r < 10 {
			log.Printf("Message %d not written to Kafka\n", i)
			i++
			time.Sleep(time.Second * 3)
			continue
		}

		partition, offset, err := conn.SendMessage(msg)
		if err != nil {
			log.Print("Could not send message (will try after 5 sec): ", err)
			time.Sleep(time.Second * 5)
		} else {
			log.Printf("Sent message: %v, partition: %v, offset: %v", msg.Value, partition, offset)
			i++
			time.Sleep(time.Second * 3)
		}

	}
}
