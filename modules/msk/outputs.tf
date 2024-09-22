# modules/msk/outputs.tf

output "msk_brokers" {
  value = aws_msk_cluster.kafka_cluster.bootstrap_brokers_tls
}
