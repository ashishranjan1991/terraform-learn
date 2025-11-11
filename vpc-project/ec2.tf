resource "aws_key_pair" "keypair" {
    key_name   = "my-key-pair"
    public_key = file("/Users/ashishranjan/.ssh/id_ed25519.pub")
  
}

resource "aws_instance" "bation" {
    ami           = var.ec_ami_id # Example AMI ID, replace with a valid one for your region
    instance_type = var.ec_instance_type
    subnet_id = aws_subnet.public-1.id
    associate_public_ip_address = true
    key_name      = aws_key_pair.keypair.key_name
    vpc_security_group_ids = [ aws_security_group.bastion-sg.id ]
    tags = {
        Name = "BationInstance"
    }
  
}
resource "null_resource" "test" {
    depends_on = [
      aws_db_instance.my_db,
      aws_instance.bation
    ]

    connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file("/Users/ashishranjan/.ssh/id_ed25519")
        host        = aws_instance.bation.public_ip
    }

    provisioner "file" {
        source      = "${path.module}/db.sql"
        destination = "/tmp/db.sql"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo yum update -y",
            "sudo yum install -y mariadb105",
            "mysql -h ${aws_db_instance.my_db.address} -u ${aws_db_instance.my_db.username} -p'${aws_db_instance.my_db.password}' < /tmp/db.sql"
        ]
    }

    # triggers = {
    #     always_run = timestamp()
    # }
}

