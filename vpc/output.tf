output "rds_endpoint" {
    value = aws_db_instance.mydb1.endpoint
}
output "bastion_ssh" {
    value = aws_instance.bastion.public_dns
  
}
output "web_private_ip" {
    value = aws_instance.web-server.private_dns
}
output "app_private_dns" {
    value = aws_instance.app-server.private_dns
}

