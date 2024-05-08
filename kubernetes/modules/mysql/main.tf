// MySQL

resource "kubernetes_namespace" "mysql" {
  metadata {
    name = var.mysql_namespace
  }
}

resource "kubernetes_secret" "mysql-secrets" {
  metadata {
    name      = "mysql-secrets"
    namespace = var.mysql_namespace
  }
  data = {
    "root-password" = "root"
  }
}

resource "kubernetes_config_map" "mysql-configmaps" {
  metadata {
    name = "mysql-configmaps"
    namespace = var.mysql_namespace
  }
  data = {
    "user" = "user"
    "password" = "password"
    "database" = "mysqldb"
  }
}

resource "kubernetes_deployment" "mysql-deployment" {
  metadata {
    name = "mysql-deployment"
    labels = {
      app = var.mysql_label
    }
    namespace = var.mysql_namespace
  }

  spec {
    replicas = var.mysql_replicas
    selector {
      match_labels = {
        app = var.mysql_label
      }
    }
    template {
      metadata {
        labels = {
          app = var.mysql_label
        }
      }
      spec {
        container {
          image = "mysql:8.0"
          name  = "mysql"
          port {
            container_port = var.mysql_port
          }
          env {
            name  = "MYSQL_PASSWORD"
            value_from {
              config_map_key_ref {
                name = "mysql-configmaps"
                key  = "password"
              }
            }
          }
          env {
            name  = "MYSQL_DATABASE"
            value_from {
              config_map_key_ref {
                name = "mysql-configmaps"
                key  = "database"
              }
            }
          }
          env {
            name  = "MYSQL_USER"
            value_from {
              config_map_key_ref {
                name = "mysql-configmaps"
                key  = "user"
              }
            }
          }
          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-secrets"
                key  = "root-password"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mysql-service" {
  metadata {
    name      = "mysql-service"
    namespace = var.mysql_namespace
  }
  spec {
    selector = {
      app = var.mysql_label
    }
    port {
      protocol    = "TCP"
      port        = 3306
      target_port = 3306
    }
  }
}

// PhpMyAdmin

resource "kubernetes_deployment" "phpmyadmin-deployment" {
  metadata {
    name      = "phpmyadmin-deployment"
    namespace = var.mysql_namespace
    labels = {
      app = var.phpmyadmin_label
    }
  }
  spec {
    replicas = var.phpmyadmin_replicas
    selector {
      match_labels = {
        app = var.phpmyadmin_label
      }
    }
    template {
      metadata {
        labels = {
          app = var.phpmyadmin_label
        }
      }
      spec {
        container {
          name  = "phpmyadmin"
          image = "phpmyadmin/phpmyadmin"
          port {
            container_port = 80
          }
          env {
            name  = "PMA_HOST"
            value = "mysql-service.mysql.svc.cluster.local"
          }
          env {
            name  = "PMA_PORT"
            value = "3306"
          }
          env {
            name  = "MYSQL_USERNAME"
            value = "root"
          }
          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "root"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "phpmyadmin-service" {
  metadata {
    name      = "phpmyadmin-service"
    namespace = "mysql"
  }
  spec {
    type = "NodePort"
    selector = {
      app = var.phpmyadmin_label
    }
    port {
      protocol    = "TCP"
      port        = var.phpmyadmin_port
      target_port = 80
      node_port   = 30002
    }
  }
}

resource "kubernetes_ingress_v1" "phpmyadmin-ingress" {
  metadata {
    name      = "phpmyadmin-ingress"
    namespace = "mysql"
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = "dataplatform.phpmyadmin.io"
      http {
        path {
          path = "/"
          backend {
            service {
              name = "phpmyadmin-service"
              port {
                number = var.phpmyadmin_port
              }
            }
          }
        }
      }
    }
  }
}