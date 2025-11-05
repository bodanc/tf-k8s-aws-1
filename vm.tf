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

resource "aws_instance" "k8s-srv-0" {
  ami           = data.aws_ssm_parameter.amzn2_linux.value
  instance_type = var.ec2_instance_type

  tags = merge(local.tags_common, { name = "${local.prefix}-srv-0"} )
}

resource "aws_instance" "k8s-srv-1" {
  ami           = data.aws_ssm_parameter.amzn2_linux.value
  instance_type = var.ec2_instance_type

  tags = merge(local.tags_common, { name = "${local.prefix}-srv-1"} )
}

resource "aws_instance" "k8s-srv-2" {
  ami           = data.aws_ssm_parameter.amzn2_linux.value
  instance_type = var.ec2_instance_type

  tags = merge(local.tags_common, { name = "${local.prefix}-srv-2"} )
}
