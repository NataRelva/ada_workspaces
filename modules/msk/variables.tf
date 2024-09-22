variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "subnet_ids" {
  description = "IDs das sub-redes para Kafka"
  type        = list(string)
}

variable "subnet_cidrs" {
  description = "CIDR blocks das sub-redes"
  type        = list(string)
}

variable "vpc_name" {
  description = "Nome da VPC"
  type        = string
}
