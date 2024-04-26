variable "mysql_namespace" {
  type        = string
  default     = "mysql"
  description = "namespace for mysql"
}

variable "mysql_port" {
  type        = number
  default     = 3306
  description = "mysql port"
}

variable "mysql_label" {
  type    = string
  default = "mysql"
}

variable "mysql_replicas" {
  type = number
  default = 1
}

variable "phpmyadmin_port" {
  type    = number
  default = 3312
}

variable "phpmyadmin_label" {
  type    = string
  default = "phpmyadmin"
}

variable "phpmyadmin_replicas" {
  type = number
  default = 1  
}

output "mysql_deployment_id" {
  value = "${kubernetes_deployment.mysql-deployment.id}"
}