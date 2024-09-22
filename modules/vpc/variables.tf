variable "cidr_block" {
  description = "CIDR block para a VPC"
  type        = string
}

variable "vpc_name" {
  description = "Nome da VPC"
  type        = string
}

variable "subnet_cidrs" {
  description = "Lista de CIDR blocks para as sub-redes"
  type        = list(string)
}

variable "availability_zones" {
  description = "Lista de zonas de disponibilidade para as sub-redes"
  type        = list(string)
}
