terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.64.0"     
  }
}
}

provider "aws" {
  alias = "smvk"
  region                  = "us-east-2"

}

# VPC, Subnet, Security Group, and EC2 instance resources
resource "aws_vpc" "jenkins_vpc1" {
  cidr_block = "10.0.0.0/16"  # Replace with your desired CIDR block for the VPC

 
}


resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.jenkins_vpc1.id
  cidr_block              = "10.0.0.0/24"
   availability_zone       = "us-east-2b" # Replace with your desired AZ

 
}

resource "aws_internet_gateway" "jenkins_vpc1" {
  vpc_id = aws_vpc.jenkins_vpc1.id

 
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.jenkins_vpc1.id

  
}

resource "aws_route" "private_internet_access" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.jenkins_vpc1.id

 
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id

 
}

resource "aws_subnet" "jenkins_subnet" {
  vpc_id     = aws_vpc.jenkins_vpc1.id
  cidr_block = "10.0.1.0/24"  # Replace with your desired CIDR block for the subnet


  
}

resource "aws_security_group" "jenkins_security_group" {
  name_prefix = "jenkins-security-group"
  description = "Jenkins security group"
   vpc_id      = aws_vpc.jenkins_vpc1.id
 

  # Define inbound rules to allow SSH and HTTP access from specific IPs or ranges
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with the specific IPs or ranges you want to allow
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with the specific IPs or ranges you want to allow
  }

    ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 8090
    to_port     = 8090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

# # # resource "aws_key_pair" "vtest1" {
# # # key_name = "vtest1"
# # # public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDhfRAZ/5dLORJac5m+O7nMLNrY7BJx/FehqRTiZ6CjIgu6LZvXoISnh7MaOdAmWzpx4wypNfnlES4XmIVRRRn8hVtDKmLKU+//UEvMNWZTaq6y5k8gHMnktr/Zy7hXT0wv4c4EF/dRVri69aPv/T+3o8jHlRo9ipziT/2lT03tbmWYQtKPnichJgMvmqVYsTq5g1aDmJS482m2JFKNuk4QtWtiHXTgH6xhNcpHzN4tZX+mrHGcd4X3J7zmZpgG3RuJaLCW+skqtFqYdIHKywG9mhAeuBiS23rxF6wE7rwxI4dxMnKdLY3ILc7j2kgCdKl/9iViYOEjyO2h7CfbcVOcytom1dllZiVizcqapEghKR721y21cEYJ9QZM+8gT5NkWF4x5/pYDiperh3Zryzyo+u0QBWQeKJvjL1Gmg06o4MqdzZp99SdvX3NyuOyybYlROJCFtJFO31qlPgrKhmX9o+eP1bdbREtlbWPeQI05uu0QlPNgg9BekKa96a9qatk= f8@DESKTOP-5AKO36V"

# # # }

# # # resource "tls_private_key" "rsa" {
# # #   # provider = aws.smvk
# # # algorithm = "RSA"
# # # rsa_bits  = 4096
# # # }


# # # resource "local_file" "Jenkins1" {

# # #   content  = tls_private_key.rsa.private_key_pem
# # #   filename =  "jenkins1"
# # # }

resource "aws_instance" "jenkins_instance1" {
  ami           = "ami-05fb0b8c1424f266b"  # Replace with your desired Jenkins-ready AMI ID
  instance_type = "t2.2xlarge"               # Replace with your desired instance type

  subnet_id                    = aws_subnet.private_subnet.id
  vpc_security_group_ids       = [aws_security_group.jenkins_security_group.id]
  key_name =  "vtest1" #aws_key_pair.vtest1.id
# #   associate_public_ip_address  = true
# #   subnet_id                    = aws_subnet.private_subnet.id
# #   vpc_security_group_ids       = [aws_security_group.jenkins_security_group.id]
  # key_name =  "vtest1" #aws_key_pair.vtest1.id
  associate_public_ip_address  = true

  tags = {
    Name = "CI-CD"
  }

}











# resource "aws_subnet" "my_subnet" {
#   vpc_id     = aws_vpc.my_vpc.id
#   cidr_block = "10.0.0.0/24"
# }
#  resource "aws_instance" "example_instance" {
#   ami           = "ami-02b8534ff4b424939"  # Replace with your desired AMI ID
#   instance_type = "t2.micro"               # Replace with your desired instance type
#   subnet_id     = aws_subnet.my_subnet.id
#   # subnet_id                    = aws_subnet.example_subnet.id
#   # vpc_security_group_ids       = [aws_security_group.example_security_group.id]
#   # associate_public_ip_address  = true

#   tags = {
#     Name = "Example EC2 Instance"
#   }
# }

# resource "aws_sns_topic" "instance_termination_topic" {
#   name = "EC2_Instance_Termination_Topic"
# }




# resource "aws_sns_topic_subscription" "email_subscription" {
#   topic_arn = aws_sns_topic.instance_termination_topic.arn
#   protocol  = "email"
#   endpoint  = "manisharavipati2000@gmail.com"  # Replace with the desired email address
# }

# resource "aws_cloudwatch_event_rule" "instance_termination_rule" {
#   name        = "EC2_Instance_Termination_Rule"
#   description = "Rule to trigger SNS topic when EC2 instance is terminated"

#   event_pattern = jsonencode({
    
#     source = ["aws.ec2"]
#     detail = {
#       state = ["terminated"]
#     }
#   })
  
# }

# resource "aws_cloudwatch_event_target" "instance_termination_target" {
#   rule      = aws_cloudwatch_event_rule.instance_termination_rule.name
#   arn       = aws_sns_topic.instance_termination_topic.arn
#   target_id = "EC2_Instance_Termination_Target"
# }



