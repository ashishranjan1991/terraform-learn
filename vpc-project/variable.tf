variable "ec_instance_type" {
  description = "Type of EC2 instance to launch"
  type        = string
  default     = "t2.micro"
}
variable "ec_ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0bdd88bd06d16ba03" 
}
variable "instance_class" {
  description = "Instance class for RDS"
  type        = string
  default     = "db.t3.micro"
  
}
variable "db_name" {
  description = "Name of the RDS database"
  type        = string
  default     = "mydatabase"
}
variable "db_username" {
  description = "Username for the RDS database"
  type        = string
  default     = "admin"
}
variable "db_password" {
  description = "Password for the RDS database"
  type        = string
  default     = "password123"
}
variable "db_allocated_storage" {
  description = "Allocated storage for the RDS database in GB"
  type        = number
  default     = 20
}


variable "zone_name" {
  description = "Hosted zone name for Route 53"
  type        = string
  default     = "example.com"
}