resource "aws_db_instance" "db1" {
    identifier = "rds-test"
    engine = "mysql"
    engine_version = "8.0"
    db_name = "database1"
    instance_class = "db.t4g.micro"
    allocated_storage = 10
    username = "admin"
    password = "ashish111111"
    parameter_group_name = "default.mysql8.0"
    skip_final_snapshot = true
    publicly_accessible = false
    backup_retention_period = 7
    apply_immediately = true

    provider = aws.dev
}

resource "aws_instance" "bastion" {
    ami           = "ami-0bdd88bd06d16ba03" # Example AMI ID, replace with a valid one for your region
    instance_type = "t2.micro"
    associate_public_ip_address = true
    tags = {
        Name = "BastionInstance"
    }
}
