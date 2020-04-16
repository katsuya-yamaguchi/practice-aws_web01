variable "env" {}
variable "az_a" {}
variable "az_c" {}
variable "instance_type" {}
variable "key_pair_name" {}
variable "subnet_id_private_web_a" {}
variable "subnet_id_private_web_c" {}
variable "security_group_web" {}

# resource "aws_instance" "web01" {
#   ami               = "ami-0c6f9336767cd9243"
#   instance_type     = var.instance_type
#   availability_zone = var.az_a
#   # placement_group = 
#   # tenancy = 
#   # host_id = 
#   # cpu_core_count = 
#   # cpu_threads_per_core = 
#   disable_api_termination              = false
#   instance_initiated_shutdown_behavior = "stop"
#   key_name                             = var.key_pair_name
#   # get_password_data = 
#   monitoring                  = true
#   vpc_security_group_ids      = [var.security_group_web]
#   subnet_id                   = var.subnet_id_private_web_a
#   associate_public_ip_address = false
#   source_dest_check           = true
#   # user_data = file("userdata.sh")
#   ipv6_address_count = 0
#   # ipv6_addresses = 
#   hibernation = false
#   volume_tags = {
#     Name = "web01"
#     Env  = var.env
#   }

#   # ebs_optimized = 
#   root_block_device {
#     volume_type           = "gp2"
#     volume_size           = "20"
#     delete_on_termination = true
#     encrypted             = false
#   }

#   # ebs_block_device {
#   #   device_name = "/dev/sda1"
#   #   # snapshot_id = ""
#   #   volume_type           = "gp2"
#   #   volume_size           = "20"
#   #   delete_on_termination = true
#   #   encrypted             = false
#   # }

#   tags = {
#     Name = "web01"
#     Env  = var.env
#   }
# }

# resource "aws_instance" "web02" {
#   ami               = "ami-0c6f9336767cd9243"
#   instance_type     = var.instance_type
#   availability_zone = var.az_c
#   # placement_group = 
#   # tenancy = 
#   # host_id = 
#   # cpu_core_count = 
#   # cpu_threads_per_core = 
#   disable_api_termination              = false
#   instance_initiated_shutdown_behavior = "stop"
#   key_name                             = var.key_pair_name
#   # get_password_data = 
#   monitoring                  = true
#   vpc_security_group_ids      = [var.security_group_web]
#   subnet_id                   = var.subnet_id_private_web_c
#   associate_public_ip_address = false
#   source_dest_check           = true
#   # user_data = file("userdata.sh")
#   ipv6_address_count = 0
#   # ipv6_addresses = 
#   hibernation = false
#   volume_tags = {
#     Name = "web02"
#     Env  = var.env
#   }

#   # ebs_optimized = 
#   root_block_device {
#     volume_type           = "gp2"
#     volume_size           = "20"
#     delete_on_termination = true
#     encrypted             = false
#   }

#   # ebs_block_device {
#   #   device_name = "/dev/sda1"
#   #   # snapshot_id = ""
#   #   volume_type           = "gp2"
#   #   volume_size           = "20"
#   #   delete_on_termination = true
#   #   encrypted             = false
#   # }

#   tags = {
#     Name = "web02"
#     Env  = var.env
#   }
# }

resource "aws_launch_template" "web" {
  name                                 = "web"
  description                          = ""
  disable_api_termination              = false
  image_id                             = "ami-0c6f9336767cd9243"
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = var.instance_type
  key_name                             = "web01"
  monitoring {
    enabled = true
  }
  vpc_security_group_ids = [var.security_group_web]

  tags = {
    Name = "web"
    Env  = var.env
  }
}


resource "aws_autoscaling_group" "web" {
  name             = "web"
  max_size         = 3
  min_size         = 1
  default_cooldown = 300
  launch_template {
    id = aws_launch_template.web.id
  }
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = false
  # load_balancers = 
  vpc_zone_identifier = [
    var.subnet_id_private_web_a,
    var.subnet_id_private_web_c
  ]
  # target_group_arns = []
  termination_policies = ["Default"]
  # placement_group = 
  metrics_granularity = "1Minute"
  # enabled_metrics           = ""
  wait_for_capacity_timeout = "10m"
  protect_from_scale_in     = false
  # service_linked_role_arn = 
}

resource "aws_autoscaling_policy" "scale_out_policy" {
  name                      = "scale_out_policy"
  autoscaling_group_name    = aws_autoscaling_group.web.name
  adjustment_type           = "ChangeInCapacity"
  estimated_instance_warmup = 300
  policy_type               = "StepScaling"

  # 80~90%
  step_adjustment {
    scaling_adjustment          = 1
    metric_interval_lower_bound = 20
    metric_interval_upper_bound = 30
  }

  # 90%~
  step_adjustment {
    scaling_adjustment          = 2
    metric_interval_lower_bound = 30
  }
}

resource "aws_autoscaling_policy" "scale_in_policy" {
  name                      = "scale_in_policy"
  autoscaling_group_name    = aws_autoscaling_group.web.name
  adjustment_type           = "ChangeInCapacity"
  estimated_instance_warmup = 300
  policy_type               = "StepScaling"

  # ~30%
  step_adjustment {
    scaling_adjustment          = -1
    metric_interval_upper_bound = 0
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 60
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
  alarm_actions       = [aws_autoscaling_policy.scale_out_policy.arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 30
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
  alarm_actions       = [aws_autoscaling_policy.scale_in_policy.arn]
}
