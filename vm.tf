# aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --region us-east-1 
# {
#     "Parameters": [
#         {
#             "Name": "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2",
#             "Type": "String",
#             "Value": "ami-06dd5c911c0d8dcdc",
#             "Version": 169,
#             "LastModifiedDate": "2025-11-05T21:25:17.759000+01:00",
#             "ARN": "arn:aws:ssm:us-east-1::parameter/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2",
#             "DataType": "text"
#         }
#     ],
#     "InvalidParameters": []
# }

data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_key_pair" "abc" {
  key_name   = ""
  public_key = ""
}

resource "aws_instance" "k8s-srv-0" {
  ami           = data.aws_ssm_parameter.amzn2_linux.value
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.subnet-private0.id
  vpc_security_group_ids = [
    aws_security_group.sec-gr-k8s.id
  ]
  key_name = aws_key_pair.abc

  tags = merge(local.tags_common, { name = "${local.prefix}-srv-0" })
}

resource "aws_instance" "k8s-srv-1" {
  ami           = data.aws_ssm_parameter.amzn2_linux.value
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.subnet-private0.id
  vpc_security_group_ids = [
    aws_security_group.sec-gr-k8s.id
  ]

  tags = merge(local.tags_common, { name = "${local.prefix}-srv-1" })
}

resource "aws_instance" "k8s-srv-2" {
  ami           = data.aws_ssm_parameter.amzn2_linux.value
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.subnet-private0.id
  vpc_security_group_ids = [
    aws_security_group.sec-gr-k8s.id
  ]

  tags = merge(local.tags_common, { name = "${local.prefix}-srv-2" })
}

# resource "aws_instance" "nginx1" {
#   ami                         = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
#   instance_type               = var.ec2_instance_type
#   subnet_id                   = aws_subnet.public_subnet1.id
#   vpc_security_group_ids      = [aws_security_group.sg_nginx.id]
#   user_data_replace_on_change = true

#   tags = merge(local.common_tags, { Name = lower("${local.prefix}-nginx1") })

#   user_data = templatefile("./templates/startup.tpl", { environment = var.environment })
# }
