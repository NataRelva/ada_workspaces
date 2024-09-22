provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source            = "../../modules/vpc"
  cidr_block        = "10.0.0.0/16"
  vpc_name          = "dev_vpc"
  subnet_cidrs      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
}

module "msk" {
  source            = "../../modules/msk"
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.subnet_ids
  subnet_cidrs      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
  vpc_name          = "dev_vpc"
}

module "lambda" {
  source            = "../../modules/lambda"
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.subnet_ids
  vpc_name          = "dev_vpc"
  msk_security_group_id = module.msk.msk_sg
  lambda_code       = "path/to/lambda/code.zip"  # Path to your Lambda ZIP file
  kafka_brokers     = module.msk.msk_brokers
  kafka_topic       = "dev-topic"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "msk_brokers" {
  value = module.msk.msk_brokers
}

output "lambda_function_name" {
  value = module.lambda.lambda_function_name
}
