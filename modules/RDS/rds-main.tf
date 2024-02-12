
resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${terraform.workspace}-subnet-group"
  subnet_ids  = var.subnet_ids
  description = "RDS Subnet group"
  tags = {
    Name = "${terraform.workspace}-subnet-group"
    }
}

resource "aws_db_instance" "rds_db" {
  identifier                 = var.identifier
  #name                       = var.identifier
  allocated_storage          = var.storage_capacity
  #snapshot_identifier        = var.snapshot_id == null ? null : var.snapshot_id
  storage_type               = var.storage_type
  engine                     = var.db_engine
  engine_version             = var.db_engine_version
  instance_class             = var.instance_class
  skip_final_snapshot        = true
  final_snapshot_identifier  = "${terraform.workspace}-db"
  auto_minor_version_upgrade = "false"
  maintenance_window         = var.maintenance_window
  backup_window              = var.backup_window
  copy_tags_to_snapshot      = "true"
  storage_encrypted          = var.storage_encryption
  monitoring_interval        = var.monitoring_interval
  # ca_cert_identifier         = "rds-ca-2019"
  backup_retention_period    = var.backup_retention_period
  parameter_group_name       = aws_db_parameter_group.rds_pg.name
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name 
  vpc_security_group_ids = var.security_group_ids
  multi_az               = var.multi_az
  replicate_source_db    = var.replicate_source_db
  password = var.passwd
  username = var.master_username

  tags = {
    Name = "db"
}
}


resource "aws_db_parameter_group" "rds_pg" {
  description = "parameter-group"
  family      = var.family
  name        = var.parameter_group_name

  parameter {
    apply_method = "immediate"
    name         = "group_concat_max_len"
    value        = "8192"
  }

  parameter {
    apply_method = "immediate"
    name         = "innodb_deadlock_detect"
    value        = "0"
  }

  parameter {
    apply_method = "immediate"
    name         = "max_allowed_packet"
    value        = "33554432"
  }

  parameter {
    apply_method = "immediate"
    name         = "binlog_format"
    value        = "ROW"
  }
}