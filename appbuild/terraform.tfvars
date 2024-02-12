vpc = {
    cidr = "10.0.0.0/16"
    tenancy = "default"
    ENV = "dev"
}

region = "us-east-1"

tags = {
  "Team"                  = "DevOps"
  "Owner"                 = "Admin"
  "ManagedBy"             = "Terraform"
  "AWS_REGION"            = "us-east-2"
}

bastion = {
    ec2_num = 1
    name = "bastion-host"
    instance_type = "t3a.medium"
    key = "dev-key"
}

sg = {
    sg_ingress = {
                ingress1 = {from="22", to="22", protocol="tcp", cidr_block="0.0.0.0/0", description="SSH"}
                ingress2 = {from="8080", to="8080", protocol="tcp", cidr_block="0.0.0.0/0", description="Jenkins"}
    }
}

frontend-asg = {
    name = "frontend-ec2"
    launch_temp_name = "frontend-lt"
    instance_type = "t3a.medium"
    volume_size = "10"
    asg_name = "frontend-asg"
    min_size = 1
    max_size = 1
    desired_capacity = 1
    key_name = "dev-key"
}

backend-asg = {
    name = "backend-ec2"
    launch_temp_name = "backend-lt"
    instance_type = "t3a.small"
    volume_size = "10"
    asg_name = "backend-asg"
    min_size = 1
    max_size = 1
    desired_capacity = 1
    key_name = "dev-key"
}

rds = {
  identifier        = "usermgmtdb"
  instance_class    = "db.t3.micro"
  db_engine         = "mysql"
  db_engine_version = "8.0.32"
  family            = "mysql8.0"
  db_username       = "nec"
  multi_az          = false
  parameter_group_name = "usermgmt-pg-group"
}

alb = {
    alb_name = "test-alb"
    internal = false
    alb_sg_ingress = {
                ingress1 = {from="80", to="80", protocol="tcp", cidr_block="0.0.0.0/0", description="HTTP"}
                ingress2 = {from="443", to="443", protocol="tcp", cidr_block="0.0.0.0/0", description="HTTPS"}
    }
}

tg = {
    application_name = "sample-app"
    application_port = 80
    application_health_check_target = "/"
}

listener_rule = {
    listener_type = "forward"
    path_pattern = "/*"
    host_header = "example.com"
}