resource "aws_instance" "ec2" {
    ami = var.ami
    instance_type = var.instance_type
    user_data = file("userdata.sh")
    tags = {
      Name="ashish"
    }
  
}