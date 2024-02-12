module "vpc" {
  source = "../modules/vpc"
  vpc_cidr = var.vpc.cidr
  vpc_tenancy = var.vpc.tenancy
  ENV = var.vpc.ENV
  tags = var.tags
}

module "app-sg" {
  source = "../modules/sg"
  id_vpc = module.vpc.vpc_id
  sg_ingress = var.sg.sg_ingress
  ENV = var.vpc.ENV
}

module "bastion" {
  source = "../modules/ec2"
    ec2_num = var.bastion.ec2_num
    name = var.bastion.name
    instance_type = var.bastion.instance_type
    ami_id = data.aws_ami.ubuntu.id
    sg_id = module.app-sg.sg_id
    subnet_id = module.vpc.pub_subnet_id
    ENV = var.vpc.ENV
    key = var.bastion.key
}

module "frontend-asg" {
  source = "../modules/asg"
  name = var.frontend-asg.name
  launch_temp_name = var.frontend-asg.launch_temp_name
  ami_id = data.aws_ami.ubuntu.id
  instance_type = var.frontend-asg.instance_type
  volume_size = var.frontend-asg.volume_size
  asg_name = var.frontend-asg.asg_name
  min_size = var.frontend-asg.min_size
  max_size = var.frontend-asg.max_size
  desired_capacity = var.frontend-asg.desired_capacity
  subnet_ids = module.vpc.priv_subnet_ids
  sg_id = module.app-sg.sg_id
  key_name = var.frontend-asg.key_name
}

module "backend-asg" {
  source = "../modules/asg"
  name = var.backend-asg.name
  launch_temp_name = var.backend-asg.launch_temp_name
  ami_id = data.aws_ami.ubuntu.id
  instance_type = var.backend-asg.instance_type
  volume_size = var.backend-asg.volume_size
  asg_name = var.backend-asg.asg_name
  min_size = var.backend-asg.min_size
  max_size = var.backend-asg.max_size
  desired_capacity = var.backend-asg.desired_capacity
  subnet_ids = module.vpc.priv_subnet_ids
  sg_id = module.app-sg.sg_id
  key_name = var.backend-asg.key_name
}

############### RDS ############################
resource "random_password" "rds_pass" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "secret_rds" {
  source = "../modules/secretmngr"
  name           = "mysql-master"

  secret_string = <<EOF
{
  "password": "${random_password.rds_pass.result}",
  "engine": "mysql"
}
EOF
}

module "rds" {
  source                  = "../modules/RDS"
  identifier              = var.rds.identifier  
  db_engine               = var.rds.db_engine
  db_engine_version       = var.rds.db_engine_version     
  master_username         = var.rds.db_username
  passwd                  = random_password.rds_pass.result
  multi_az                = var.rds.multi_az
  instance_class          = var.rds.instance_class
  parameter_group_name    = var.rds.parameter_group_name
  family                  = var.rds.family 
  security_group_ids      = [module.app-sg.sg_id]
  subnet_ids              = module.vpc.priv_subnet_ids
}

############################## ALB ##############################
module "alb" {
    source = "../modules/alb"
    alb_name = var.alb.alb_name
    internal = var.alb.internal
    subnets_id = module.vpc.pub_subnet_id
    alb_sg_ingress = var.alb.alb_sg_ingress
    id_vpc = module.vpc.vpc_id
}

module "target_group" {
    depends_on = [ module.alb ]
    source = "../modules/target-group"
    application_name = var.tg.application_name
    application_port = var.tg.application_port
    application_health_check_target = var.tg.application_health_check_target
    vpc_id = module.vpc.vpc_id
}

module "listener_rule" {
    source = "../modules/listener-rule"
    listener_arn = module.alb.alb_http_listener_arn
    target_group_arn = module.target_group.target_group_arn
    listener_type = var.listener_rule.listener_type
    path_pattern = var.listener_rule.path_pattern
    host_header = var.listener_rule.host_header
}