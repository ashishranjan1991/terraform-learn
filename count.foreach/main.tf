variable "instance_count" {
  description = "Number of EC2 instances to launch"
  type        = list(string)
  default = ["dev","prod","test"]
}

resource "aws_instance" "app_server" {
// count         = length(var.instance_count)
  for_each = toset(var.instance_count)
  ami           = "ami-07860a2d7eb515d9a"
  instance_type = "t2.micro"
  tags = {
      //Name =  "app-server-${var.instance_count[count.index]}"
      Name =  "web-server-${each.value}"
  }
}