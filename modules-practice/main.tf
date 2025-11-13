module "vpc" {
  source = "/Users/ashishranjan/Documents/terraform/terraform-learn/modules-practice/vpc"

  vpc_name            = "my-terraform-vpc"
  aws_region          = "us-east-1"
  az_1                = "us-east-1a"
  az_2                = "us-east-1b"
  vpc_cidr_block      = "10.0.0.0/16"
  subnet_1_cidr_block = "10.0.1.0/24"
  subnet_2_cidr_block = "10.0.2.0/24"

}
module "ec2" {
  source = "/Users/ashishranjan/Documents/terraform/terraform-learn/modules-practice/ec2"

  aws_instance  = "t2.micro"
  ami_id        = "ami-0cae6d6fe6048ca2c"
  aws_vpc       = module.name_vpc.vpc_id
  subnet_id     = module.name_vpc.subnet_1_id
  instance_tags = "dev-ashish"
}
module "rds" {
  source = "/Users/ashishranjan/Documents/terraform/terraform-learn/modules-practice/rds"

  aws_db_instance      = "db.t3.micro"
  username             = "admin"
  password             = "123456789"
  db_name              = "mydatabase"
  db_allocated_storage = 20
  db_identifier        = "mydbinstance"
  db_engine            = "mysql"
  aws_db_subnet_group  = module.name_vpc.db_subnet_group
  db_subnet_1          = module.name_vpc.subnet_1_id
  db_subnet_2          = module.name_vpc.subnet_2_id
}
module "s3" {
  source = "/Users/ashishranjan/Documents/terraform/terraform-learn/modules-practice/s3"

  bucket_name = "ashish-vpc-terraform-2024"
}
output "vpc_id" {
  value = module.name_vpc.vpc_id
}
output "subnet_1_id" {
  value = module.name_vpc.subnet_1_id
}
output "subnet_2_id" {
  value = module.name_vpc.subnet_2_id
}
output "ec2_instance_id" {
  value = module.name_ec2.ec2_instance_id
}
output "rds_instance_endpoint" {
  value = module.name_rds.rds_instance_endpoint
}
output "s3_bucket_arn" {
  value = module.name_s3.s3_bucket_arn
}
