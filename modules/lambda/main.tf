# Security Group para Lambda
resource "aws_security_group" "lambda_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    security_groups = [var.msk_security_group_id]  # Comunicação com Kafka
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

# Função Lambda
resource "aws_lambda_function" "kafka_consumer" {
  function_name = "${var.vpc_name}_kafka_consumer"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  filename      = var.lambda_code  # Arquivo zipado com o código da função Lambda

  vpc_config {
    subnet_ids         = var.subnet_ids  # Sub-redes associadas à Lambda
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      KAFKA_BROKERS = var.kafka_brokers
      KAFKA_TOPIC   = var.kafka_topic
    }
  }

  tags = {
    Name = "${var.vpc_name}_kafka_consumer"
  }
}

# Role para Lambda
resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.vpc_name}_lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

# Policies para permitir Lambda acessar Kafka e logs
resource "aws_iam_role_policy" "lambda_policy" {
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:AlterTopic"
        ],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}
