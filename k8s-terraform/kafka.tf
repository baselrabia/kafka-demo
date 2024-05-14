# Create a new namespace
resource "kubernetes_namespace" "kafka-namespace" {
  metadata {
    name = "kafka-namespace"
  }
}

# Zookeeper Deployment
resource "kubernetes_deployment" "zookeeper" {
  metadata {
    name      = "zookeeper"
    namespace = kubernetes_namespace.kafka-namespace.metadata.0.name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "zookeeper"
      }
    }
    template {
      metadata {
        labels = {
          app = "zookeeper"
        }
      }
      spec {
        container {
          name  = "zookeeper"
          image = "wurstmeister/zookeeper"
          port {
            container_port = 2181
          }
        }
      }
    }
  }
}

# Zookeeper Service
resource "kubernetes_service" "zookeeper-service" {
  metadata {
    name      = "zookeeper"
    namespace = kubernetes_namespace.kafka-namespace.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.zookeeper.spec.0.template.0.metadata.0.labels.app
    }
    port {
      port        = 2181
      target_port = 2181
    }
  }
}

# Kafka Deployment
resource "kubernetes_deployment" "kafka" {
  metadata {
    name      = "kafka"
    namespace = kubernetes_namespace.kafka-namespace.metadata.0.name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "kafka"
      }
    }
    template {
      metadata {
        labels = {
          app = "kafka"
        }
      }
      spec {
        container {
          name  = "kafka"
          image = "wurstmeister/kafka"
          port {
            container_port = 9092
          }
          env {
            name  = "KAFKA_BROKER_ID"
            value = "1"
          }
          env {
            name  = "KAFKA_LISTENERS"
            value = "PLAINTEXT://:9092"
          }
          env {
            name  = "KAFKA_ADVERTISED_LISTENERS"
            value = "PLAINTEXT://:9092"
          }
          env {
            name  = "KAFKA_ZOOKEEPER_CONNECT"
            value = "zookeeper.kafka-namespace:2181"
          }
          env {
            name  = "ALLOW_PLAINTEXT_LISTENER"
            value = "yes"
          }
          env {
            name  = "TOPIC_AUTO_CREATE"
            value = "false"
          }
          env {
            name  = "DELETE_TOPIC_ENABLE"
            value = "true"
          }
        }
      }
    }
  }
}

# Kafka Service
resource "kubernetes_service" "kafka-service" {
  metadata {
    name      = "kafka"
    namespace = kubernetes_namespace.kafka-namespace.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.kafka.spec.0.template.0.metadata.0.labels.app
    }
    port {
      port        = 9092
      target_port = 9092
    }
  }
}