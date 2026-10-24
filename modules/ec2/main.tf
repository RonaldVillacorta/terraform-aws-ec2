#Security Group for EC2 instance
resource "aws_security_group" "sg_ec2" {
  name        = "${var.project_name}-security_group_ec2"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = "vpc-0e8a9965bfbed9d69"

  tags = {
    Name = "Security Group for EC2 instance"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.sg_ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg_ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.sg_ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}


#EC2 instance
resource "aws_instance" "ec2_tf" {
  ami                    = local.amis[var.ami]
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg_ec2.id]

  user_data                   = var.user_data
  user_data_replace_on_change = true

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.id

  root_block_device {
    volume_size = var.volumen_size
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project_name}-Ec2 Instance"
  }
}

#Elastic IP for EC2 instance
resource "aws_eip" "eip" {
  instance = aws_instance.ec2_tf.id
}

#IAM Role for EC2 instance
resource "aws_iam_role" "ec2_iam_role" {
  name = "${var.project_name}-ec2_iam_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Attach the SSM policy to the IAM role
resource "aws_iam_policy_attachment" "ssm_policy_attachment" {
  name       = "${var.project_name}_ssm_policy_attachment"
  roles      = [aws_iam_role.ec2_iam_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create an IAM instance profile and associate it with the IAM role
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2_profile"
  role = aws_iam_role.ec2_iam_role.name
}
