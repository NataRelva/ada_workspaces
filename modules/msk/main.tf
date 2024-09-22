# Criação de um Security Group para MSK
resource "aws_security_group" "msk_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = var.subnet_cidrs
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

# Cluster Kafka gerenciado pela AWS MSK
resource "aws_msk_cluster" "kafka_cluster" {
  cluster_name           = "msk-cluster-${var.vpc_name}"
  kafka_version          = "2.8.1"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = "kafka.m5.large"
    client_subnets  = var.subnet_ids
    security_groups = [aws_security_group.msk_sg.id]
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }

  tags = {
    Name = "${var.vpc_name}_msk"
  }
}

