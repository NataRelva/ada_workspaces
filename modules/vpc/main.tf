# modules/vpc/main.tf

resource "aws_vpc" "main_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# Sub-redes Públicas
resource "aws_subnet" "public_subnet" {
  count                 = length(var.subnet_cidrs)
  vpc_id                = aws_vpc.main_vpc.id
  cidr_block            = var.subnet_cidrs[count.index]
  availability_zone     = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}_subnet_${count.index + 1}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.vpc_name}_igw"
  }
}

# Tabela de Roteamento Pública
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "${var.vpc_name}_route_table"
  }
}

# Associação de sub-redes à Tabela de Roteamento
resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.subnet_cidrs)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Security Group para Lambdas (permitindo acesso ao Kafka/MSK)
resource "aws_security_group" "lambda_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = var.subnet_cidrs  # Pode ser ajustado com regras mais específicas
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}_lambda_sg"
  }
}

# Security Group para MSK
resource "aws_security_group" "msk_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = var.subnet_cidrs  # Pode ser ajustado para sub-redes específicas
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}_msk_sg"
  }
}
