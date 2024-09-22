output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "lambda_security_group_id" {
  value = aws_security_group.lambda_sg.id
}

output "msk_security_group_id" {
  value = aws_security_group.msk_sg.id
}
