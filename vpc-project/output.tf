output "frontend_alb_dns" {
  description = "DNS name of the frontend ALB"
  value       = aws_lb.frontend_alb.dns_name
  
}
output "backend_alb_dns" {
  description = "DNS name of the backend ALB"
  value       = aws_lb.backend_alb.dns_name
}
output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.my_db.endpoint
  
}
output "rds_read_replica_endpoint" {
  description = "Endpoint of the RDS read replica"
  value       = aws_db_instance.db-read-replica.endpoint
}
