# Create a new instance of the latest Ubuntu 14.04 on an
# t2.micro node with an AWS Tag naming it "HelloWorld"
provider "aws" {
  region = "us-east-1"
}




# ++++++++++++++++++++ GET MY REAL IP +++++++++++++++++++++
data "http" "my_ip_addr" {
  url = "http://ipv4.icanhazip.com"
}


# ++++++++++++++++++++ SECURITY GROUPS +++++++++++++++++++++

resource "aws_security_group" "devmachine" {
  name        = "devmachine-sg"
  description = "Allow TLS inbound traffic"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["${chomp(data.http.my_ip_addr.body)}/32"] # add a CIDR block here
  }
  ingress {
    # SSH (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["${chomp(data.http.my_ip_addr.body)}/32"] # add a CIDR block here
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]

  }
}

# ++++++++++++++++++++ AMI +++++++++++++++++++++

data "aws_ami" "amazon-linux-2" {
 most_recent = true
  owners = ["amazon"]


 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }


 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

# ++++++++++++++++++++ IAM +++++++++++++++++++++
data "aws_iam_policy_document" "dev" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "dev" {
  name        = "devmachine_policy"
  path        = "/"
  description = "My devmachine policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "dev" {
  name               = "devmachine_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.dev.json
}

resource "aws_iam_role_policy_attachment" "dev" {
  policy_arn = aws_iam_policy.dev.arn
  role = aws_iam_role.dev.name
}

resource "aws_iam_instance_profile" "dev" {
  name = "devmachine_profile"
  role = aws_iam_role.dev.name
}


# ++++++++++++++++++++ EC2 Instance +++++++++++++++++++++

resource "aws_instance" "devmachine" {
 ami                         = data.aws_ami.amazon-linux-2.id
 associate_public_ip_address = true
 instance_type               = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.dev.name
 key_name                    = "shuraosipov-dev-machine"
 vpc_security_group_ids      = [aws_security_group.devmachine.id]
  root_block_device {
    volume_size = 32
  }

  provisioner "file" {
    source      = "install.sh"
    destination = "/tmp/install.sh"
    connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = file("~/shuraosipov-dev-machine.pem")
      host = self.public_ip

  }

  }

  provisioner "remote-exec" {

    inline = [
      "chmod +x /tmp/install.sh",
      "/tmp/install.sh",
    ]
    connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = file("~/shuraosipov-dev-machine.pem")
      host = self.public_ip

  }

  }
}

# ++++++++++++++++++++ OUTPUTS +++++++++++++++++++++

output "ip_address" {
  value = aws_instance.devmachine.public_ip
}
