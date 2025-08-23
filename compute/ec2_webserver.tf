resource "aws_instance" "web_instance" {
  ami           = var.ec2_web_instance_ami_id
  instance_type = var.ec2_web_instance_type
  key_name      = var.ec2_web_key_name

  subnet_id                   = var.vpc_public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash -ex

  amazon-linux-extras install nginx1 -y
  echo "<h1>Hola mundo</h1>" >  /usr/share/nginx/html/index.html 
  systemctl enable nginx
  systemctl start nginx
  EOF

  tags = merge(var.tags, { Name = "ec2-${var.app_name}-webserver-${var.environment}" })
}

resource "aws_security_group" "web_sg" {
  name   = "secgroup-${var.app_name}-webserver-${var.environment}"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}