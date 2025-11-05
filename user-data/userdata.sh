#!bin/bash
    yum update -y
    yum install -y httpd
    systemctl enable httpd
    systemctl start httpd
    echo "<h1>Hello from Terraform EC2 Instance</h1>" > /var/www/html/index.html