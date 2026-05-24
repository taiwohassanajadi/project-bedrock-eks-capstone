resource "random_password" "mysql_password" {
  length  = 16
  special = false
}

resource "random_password" "postgres_password" {
  length  = 16
  special = false
}

resource "aws_security_group" "rds" {
  name        = "${var.cluster_name}-rds-sg"
  description = "Allow database access from EKS VPC CIDR"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "MySQL from EKS VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    description = "PostgreSQL from EKS VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-rds-sg"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.cluster_name}-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "${var.cluster_name}-db-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {
  identifier              = "bedrock-mysql"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "catalog"
  username                = "adminuser"
  password                = random_password.mysql_password.result
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  publicly_accessible     = false
  skip_final_snapshot     = true
  backup_retention_period = 0

  tags = {
    Name = "bedrock-mysql"
  }
}

resource "aws_db_instance" "postgres" {
  identifier              = "bedrock-postgres"
  engine                  = "postgres"
  engine_version          = "16"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "orders"
  username                = "adminuser"
  password                = random_password.postgres_password.result
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  publicly_accessible     = false
  skip_final_snapshot     = true
  backup_retention_period = 0

  tags = {
    Name = "bedrock-postgres"
  }
}

resource "aws_dynamodb_table" "main" {
  name         = "bedrock-retail-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "bedrock-retail-table"
  }
}

resource "aws_secretsmanager_secret" "mysql" {
  name = "bedrock/mysql"

  tags = {
    Name = "bedrock-mysql-secret"
  }
}

resource "aws_secretsmanager_secret_version" "mysql" {
  secret_id = aws_secretsmanager_secret.mysql.id

  secret_string = jsonencode({
    username = aws_db_instance.mysql.username
    password = random_password.mysql_password.result
    host     = aws_db_instance.mysql.address
    port     = 3306
    database = aws_db_instance.mysql.db_name
  })
}

resource "aws_secretsmanager_secret" "postgres" {
  name = "bedrock/postgres"

  tags = {
    Name = "bedrock-postgres-secret"
  }
}

resource "aws_secretsmanager_secret_version" "postgres" {
  secret_id = aws_secretsmanager_secret.postgres.id

  secret_string = jsonencode({
    username = aws_db_instance.postgres.username
    password = random_password.postgres_password.result
    host     = aws_db_instance.postgres.address
    port     = 5432
    database = aws_db_instance.postgres.db_name
  })
}