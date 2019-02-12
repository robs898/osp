variable "aws_access_key" {}
variable "aws_secret_key" {}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "us-east-1"
}

resource "aws_security_group" "stream1-sg" {
  name = "stream1-sg"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deploy" {
  key_name   = "deploy"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCu/gfoAPfzAtChaCOaO1HEOVsw6dX0lBMEQQjyEHepikeOc2Dz7OWem7YPNXRbCpaxSlWG2qbokH7GZIBEQamzW9SNYtLup7+xRAs0BSpoqaGpdTmJH6xscWqmJwfLXUi3P4eeJWPNRFllM6jbUV1SFfQXvgpXsZHbjT+2bJrPiIsRJ1GORNRYe+Q1+2LUl/0UvxZoCnRtdJyaAXamH2x9+5KU6KG83N5HTAOTbYGWNLO0hX5eFeLQ5DmDIeMmKXTPjNJXsmAaxe0ay9KQC3h96FPD2vP7F2mS8wR4YboJbw0JEIULkBy8B3rzhJdHkGSN73kkIHSv36rwiXw82Y7x"
}

resource "aws_instance" "stream1" {
  ami                    = "ami-068613db13f99b0f7"
  instance_type          = "t2.large"
  vpc_security_group_ids = ["${aws_security_group.stream1-sg.id}"]
  count                  = 1
  key_name               = "deploy"

  user_data = <<EOF
#!/bin/bash
sudo sysctl -w net.core.rmem_max=2097152
sudo sysctl -w net.core.rmem_default=2097152
sudo sysctl -w net.core.wmem_max=2097152
sudo sysctl -w net.core.wmem_default=2097152
# ffmpeg -i 'udp://localhost:1234?fifo_size=100000&buffer_size=10000000' \
#        -s 1280x720 /dev/shm/03.m3u8 \
#        -s 640x480 /dev/shm/02.m3u8 \
#        -s 320x240 /dev/shm/01.m3u8
EOF
}
