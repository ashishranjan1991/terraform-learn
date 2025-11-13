module "vpc" {
  source = "/Users/ashishranjan/Documents/terraform/terraform-learn/modules-practice/vpc"

  vpc_name            = "my-terraform-vpc"
 // aws_region          = "us-east-1"
  az_1                = "us-east-1a"
  az_2                = "us-east-1b"
  cidr_block          = "10.0.0.0/16"
  subnet_1_cidr       = "10.0.1.0/24"
  subnet_2_cidr       = "10.0.2.0/24"

}
module "ec2" {
  source = "/Users/ashishranjan/Documents/terraform/terraform-learn/modules-practice/ec2"

  instance_type  = "t2.micro"
  ami_id        = "ami-0cae6d6fe6048ca2c"
  subnet_id     = module.vpc.subnet_1_id
  instance_tags = "dev-ashish"
}
module "rds" {
  source = "/Users/ashishranjan/Documents/terraform/terraform-learn/modules-practice/rds"

  instance_class      = "db.t3.micro"
  username             = "admin"
  password             = "123456789"
  db_name              = "mydatabase"
  db_allocated_storage = 20
  db_identifier        = "mydbinstance"
  subnet_1             = module.vpc.subnet_1_id
  subnet_2             = module.vpc.subnet_2_id
}
module "s3" {
  source = "/Users/ashishranjan/Documents/terraform/terraform-learn/modules-practice/s3"

  bucket_name = "ashish-vpc-terraform-2024"
}
