resource "aws_security_group" "workstation-access" {
  name   = "allow_gocd_connection"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ "Name" = "sc-server-wrks" }, var.module_tags, var.tags)
}

resource "aws_security_group_rule" "gocd-server-ingress-workstation-http" {
  cidr_blocks       = [var.workstation-external-cidr]
  description       = "Allow workstation to communicate with HTTP to the GoCD server"
  from_port         = 8153
  protocol          = "tcp"
  security_group_id = aws_security_group.workstation-access.id
  to_port           = 8153
  type              = "ingress"
}

resource "aws_security_group_rule" "gocd-server-ingress-workstation-https" {
  cidr_blocks       = [var.workstation-external-cidr]
  description       = "Allow workstation to communicate with HTTP to the GoCD server"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.workstation-access.id
  to_port           = 80
  type              = "ingress"
}

resource "aws_security_group_rule" "gocd-server-ingress-workstation-ssh" {
  count             = var.ssh_access ? 1 : 0
  cidr_blocks       = [var.workstation-external-cidr]
  description       = "Allow workstation to communicate with SSH to the GoCD server"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.workstation-access.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_instance" "gocd-server" {
  ami           = var.ami_id
  instance_type = var.instance_type

  availability_zone           = var.vpc_az
  subnet_id                   = var.vpc_subnet_id
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.workstation-access.id]

  user_data = data.template_file.gocd-server-install.rendered

  tags = merge({ "Name" = "go-server" }, var.module_tags, var.tags)
}

data "template_file" "gocd-server-install" {
  template = file("${path.module}/gocd-server.sh")
}
