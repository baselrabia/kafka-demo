
# Define a Deployment resource for your Go application
resource "kubernetes_deployment" "go-app-receiver" {
  metadata {
    name      = "go-app-receiver"
    namespace = kubernetes_namespace.go-app-namespace.metadata.0.name
    labels = {
      app = "go-app-receiver"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "go-app-receiver"
      }
    }
    template {
      metadata {
        labels = {
          app = "go-app-receiver"
        }
      }
      spec {
        container {
          image = "go-app-receiver:v1"  
          name  = "go-app-receiver"
          env {
            name = "BROKERS"
            value = "kafka:9092" 
          }
          env {
            name =  "TOPICS"
            value = "sender1,sender2"
          }
          
          port {
            container_port = 8082
          }
        }
      }
    }
  }
}

# Define a Service resource for your Go application
resource "kubernetes_service" "go-app-receiver-service" {
  metadata {
    name      = "go-app-receiver-service"
    namespace = kubernetes_namespace.go-app-namespace.metadata.0.name
  }
  spec {
    selector = {
      app = "go-app-receiver"
    }
    port {
      port        = 82
      target_port = 8082
    }
   }
}
