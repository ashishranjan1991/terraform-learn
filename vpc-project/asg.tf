# data "aws_ami" "web" {
#     most_recent = true

#     filter {
#         name   = "name"
#         values = ["frontend-image"]
#     }



#     owners = ["137112412989"] # Amazon
  
# }

# resource "aws_launch_configuration" "web-asg" {
#     name          = "web-asg-launch-config"
#     image_id      = aws_ami.web.id # Replace with your AMI ID
#     instance_type = "t2.micro"

#     lifecycle {
#         create_before_destroy = true
#     }
# }

# resource "aws_autoscaling_group" "example" {
#     launch_configuration = aws_launch_configuration.example.id
#     min_size             = 1
#     max_size             = 3
#     desired_capacity     = 2
#     vpc_zone_identifier  = [aws_subnet.web-1.id, aws_subnet.web-2.id] 

#     tag {
#         key                 = "Name"
#         value               = "example-asg"
#         propagate_at_launch = true
#     }
# }

# resource "aws_autoscaling_policy" "scale_up" {
#     name                   = "scale-up"
#     scaling_adjustment     = 1
#     adjustment_type        = "ChangeInCapacity"
#     cooldown               = 300
#     autoscaling_group_name = aws_autoscaling_group.example.name
# }

# resource "aws_autoscaling_policy" "scale_down" {
#     name                   = "scale-down"
#     scaling_adjustment     = -1
#     adjustment_type        = "ChangeInCapacity"
#     cooldown               = 300
#     autoscaling_group_name = aws_autoscaling_group.example.name
# }

# data "aws_ami" "app" {
#     most_recent = true

#     filter {
#         name   = "name"
#         values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#     }

#     filter {
#         name   = "virtualization-type"
#         values = ["hvm"]
#     }

#     owners = ["137112412989"] # Amazon
  
# }

# resource "aws_launch_configuration" "app-asg" {
#     name          = "app-asg-launch-config"
#     image_id      = data.aws_ami.app.id 
#     instance_type = "t2.micro"

#     lifecycle {
#         create_before_destroy = true
#     }
# }
# resource "aws_autoscaling_group" "app-asg" {
#     launch_configuration = aws_launch_configuration.app-asg.id
#     min_size             = 1
#     max_size             = 3
#     desired_capacity     = 2
#     vpc_zone_identifier  = [aws_subnet.app-1.id, aws_subnet.app-2.id] 

#     tag {
#         key                 = "Name"
#         value               = "app-asg"
#         propagate_at_launch = true
#     }
# }
# resource "aws_autoscaling_policy" "app-scale-up" {
#     name                   = "app-scale-up"
#     scaling_adjustment     = 1
#     adjustment_type        = "ChangeInCapacity"
#     cooldown               = 300
#     autoscaling_group_name = aws_autoscaling_group.app-asg.name
# }
# resource "aws_autoscaling_policy" "app-scale-down" {
#     name                   = "app-scale-down"
#     scaling_adjustment     = -1
#     adjustment_type        = "ChangeInCapacity"
#     cooldown               = 300
#     autoscaling_group_name = aws_autoscaling_group.app-asg.name
# }
