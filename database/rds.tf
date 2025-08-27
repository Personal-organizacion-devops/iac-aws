resource "aws_db_instance" "rds_mysql" {
  identifier                = "rds-${var.app_name}-mysql-${var.environment}"
  engine                    = var.rds_engine
  engine_version            = var.rds_engine_version
  instance_class            = var.rds_instance_class
  allocated_storage         = 20
  storage_type              = "gp2"
  username                  = "admin"
  password                  = random_password.rds_password.result
  skip_final_snapshot       = false
  db_subnet_group_name      = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids    = [aws_security_group.rds_sg.id]
  publicly_accessible       = false
  availability_zone         = var.vpc_single_availability_zone
  multi_az                  = false
  deletion_protection       = false
  final_snapshot_identifier = "rds-${var.app_name}-${var.environment}-snapshot"

  tags = var.tags
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-private-subnet-${var.app_name}-gp-${var.environment}"
  subnet_ids = var.vpc_private_subnets

  tags = merge(var.tags, {
    Name = "rds-${var.app_name}-subnet-group-${var.environment}"
  })
}

resource "aws_security_group" "rds_sg" {
  name   = "rds-${var.app_name}-sg-${var.environment}"
  vpc_id = var.vpc_id

  ingress {
    description     = "Access from EKS nodes"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.security_group_eks]
  }

  ingress {
    description     = "Access from EC2 Webserver"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.security_group_web]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "random_password" "rds_password" {
  length  = 16
  special = true
}