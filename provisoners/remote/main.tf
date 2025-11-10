resource "aws_db_instance" "mydb" {
    identifier = "mydb-instance"
    engine = "mysql"
    instance_class = "db.t3.micro"
    username = "admin"
    password = "password123"
    db_name= "mydatabase"
    allocated_storage = 20
    skip_final_snapshot = true
    publicly_accessible = true
    
}

resource "aws_key_pair" "keypair" {
    key_name   = "my-key-pair"
    public_key = file("/Users/ashishranjan/.ssh/id_ed25519.pub")
  
}
resource "aws_instance" "app_server" {
    ami           = "ami-0bdd88bd06d16ba03" 
    instance_type = "t2.micro"
    key_name      = aws_key_pair.keypair.key_name
    associate_public_ip_address = true
    tags = {
        Name = "AppServer"
    }
}


resource "null_resource" "test" {
    depends_on = [
      aws_db_instance.mydb,
      aws_instance.app_server
    ]

    connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file("/Users/ashishranjan/.ssh/id_ed25519")
        host        = aws_instance.app_server.public_ip
    }

    provisioner "file" {
        source      = "${path.module}/test.sql"
        destination = "/tmp/test.sql"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo yum update -y",
            "sudo yum install -y mariadb105",
            "mysql -h ${aws_db_instance.mydb.address} -u ${aws_db_instance.mydb.username} -p'${aws_db_instance.mydb.password}' < /tmp/test.sql"
        ]
    }

    triggers = {
        always_run = timestamp()
    }
}