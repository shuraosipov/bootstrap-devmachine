# Create a new instance of the latest Ubuntu 14.04 on an
# t2.micro node with an AWS Tag naming it "HelloWorld"
provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "devmachine" {
  name        = "devmachine-sg"
  description = "Allow TLS inbound traffic"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"] # add a CIDR block here
  }
  ingress {
    # SSH (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"] # add a CIDR block here
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]

  }
}

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


resource "aws_instance" "devmachine" {
 ami                         = data.aws_ami.amazon-linux-2.id
 associate_public_ip_address = true
 instance_type               = "t2.micro"
 key_name                    = "shuraosipov-dev-machine"
 vpc_security_group_ids      = [aws_security_group.devmachine.id]
  root_block_device {
    volume_size = 32
  }

// user_data = file("install.sh")
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



output "ip_address" {
  value = aws_instance.devmachine.public_ip
}