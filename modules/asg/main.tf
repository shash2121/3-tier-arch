resource "aws_launch_template" "launch_temp" {
  name_prefix   = var.launch_temp_name
  image_id      = var.ami_id 
  instance_type = var.instance_type 

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = var.volume_size
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.name
    }
  }
   vpc_security_group_ids = [var.sg_id]
   key_name = var.key_name
}

resource "aws_autoscaling_group" "asg" {
  name             = var.asg_name
  launch_template {
    id = aws_launch_template.launch_temp.id
    version = "$Latest" 
  }
  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity
  vpc_zone_identifier = "${var.subnet_ids}"
}
