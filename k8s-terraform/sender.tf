
# Define a Deployment resource for your Go application
resource "kubernetes_deployment" "go-app-sender1" {
  metadata {
    name      = "go-app-sender1"
    namespace = kubernetes_namespace.go-app-namespace.metadata.0.name
    labels = {
      app = "go-app-sender1"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "go-app-sender1"
      }
    }
    template {
      metadata {
        labels = {
          app = "go-app-sender1"
        }
      }
      spec {
        container {
          image = "go-app-sender:v1"  
          name  = "go-app-sender1"
          env {
            name = "KAFKA_HOST"
            value = "kafka:9092" 
          }
          env {
            name =  "TOPIC"
            value = "sender1"
          }
          env {
            name = "USER"
            value = "Anna"
          }
          
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

# Define a Service resource for your Go application
resource "kubernetes_service" "go-app-sender1-service" {
  metadata {
    name      = "go-app-sender1-service"
    namespace = kubernetes_namespace.go-app-namespace.metadata.0.name
  }
  spec {
    selector = {
      app = "go-app-sender1"
    }
    port {
      port        = 80
      target_port = 8080
    }
   }
}


# Define a Deployment resource for your Go application
resource "kubernetes_deployment" "go-app-sender2" {
  metadata {
    name      = "go-app-sender2"
    namespace = kubernetes_namespace.go-app-namespace.metadata.0.name
    labels = {
      app = "go-app-sender2"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "go-app-sender2"
      }
    }
    template {
      metadata {
        labels = {
          app = "go-app-sender2"
        }
      }
      spec {
        container {
          image = "go-app-sender:v1"  
          name  = "go-app-sender2"
          env {
            name = "KAFKA_HOST"
            value = "kafka:9092" 
          }
          env {
            name =  "TOPIC"
            value = "sender2"
          }
          env {
            name = "USER"
            value = "Bob"
          }

          port {
            container_port = 8081
          }
        }
      }
    }
  }
}

# Define a Service resource for your Go application
resource "kubernetes_service" "go-app-sender2-service" {
  metadata {
    name      = "go-app-sender2-service"
    namespace = kubernetes_namespace.go-app-namespace.metadata.0.name
  }
  spec {
    selector = {
      app = "go-app-sender2"
    }
    port {
      port        = 81
      target_port = 8081
    }
   }
}
