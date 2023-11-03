#//Create load balancer
#
#resource "aws_lb" "app_alb" {
#  name               = "app-alb"
#  internal           = false  # Set to "true" for internal ALB
#  load_balancer_type = "application"
#
#  enable_deletion_protection = false
#
#  subnets         = [aws_subnet.public_subnet.id]  # Specify your subnets
#  security_groups = [aws_security_group.jenkins-sec-group.id]  # Specify your security groups
#}
#
#
#resource "aws_launch_configuration" "my_launch_config" {
#  name_prefix   = "my-launch-config-"
#  image_id      = var.ecr_url  # Replace with your desired AMI ID
#  instance_type = "t2.micro"     # Choose an appropriate instance type
#  key_name      = var.key-pair
#
#  # Additional configuration for the launch configuration (e.g., user data, IAM role, etc.)
#}
#resource "aws_autoscaling_group" "my_asg" {
#  name = "my-asg"
#  min_size = 1
#  max_size = 3
#  desired_capacity = 2
#  launch_configuration = aws_launch_configuration.my_launch_config.name
#  vpc_zone_identifier = [aws_subnet.public_subnet.id]  # Specify your subnets
#}
#
## Connect the ALB with the ASG (if using ASG)
#resource "aws_lb_target_group" "my_target_group" {
#  name     = "my-target-group"
#  port     = 80
#  protocol = "HTTP"
#  vpc_id   = aws_vpc.jenkins_vps.id  # Replace with your VPC ID
#
#  health_check {
#    path = "/"
#    protocol = "HTTP"
#    port = "80"
#    healthy_threshold = 2
#    unhealthy_threshold = 2
#    timeout = 3
#    interval = 30
#  }
#}
#
#resource "aws_lb_listener" "my_alb_listener" {
#  load_balancer_arn = aws_lb.app_alb.arn
#  port              = "80"
#  protocol          = "HTTP"
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.my_target_group.arn
#  }
#}
#
#output "alb_dns_name" {
#  value = aws_lb.app_alb.dns_name
#}
