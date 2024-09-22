variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "subnet_ids" {
  description = "IDs das sub-redes"
  type        = list(string)
}

variable "vpc_name" {
  description = "Nome da VPC"
  type        = string
}

variable "msk_security_group_id" {
  description = "ID do Security Group do MSK"
  type        = string
}

variable "lambda_code" {
  description = "Caminho do arquivo zip da função Lambda"
  type        = string
}

variable "kafka_brokers" {
  description = "Lista de brokers Kafka"
  type        = string
}

variable "kafka_topic" {
  description = "Nome do tópico Kafka"
  type        = string
}
