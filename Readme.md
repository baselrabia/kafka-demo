# Golang Kafka Terraform Task 

i start by using docker-compose file which help to develop the golang app so all u nee to do is to run ` docker-compose up -d`, in additional you need to create two topics manually using the makefile i had some commands 
```bash 
 make create-topic topic=sender1

 make create-topic topic=sender2
```

### Terraform 

first need to build the golang images, you need to eval minikube env so you can reach the local images you will create 

```bash
    cd go-consumer/src

    eval $(minikube docker-env)

    docker build -t go-app-receiver:v1 .

    cd ../../producer/src 

    docker build -t go-app-sender:v1 .

```

to run the App using terraform 

```bash 
 cd ../../k8s-terraform

 # then 
 terraform apply 
 

```