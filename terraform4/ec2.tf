data "aws_ami" "my_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

module "my_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.4"

  name                        = "tf-rackula-server"
  ami                         = data.aws_ami.my_ami.id
  instance_type               = "t3.micro"
  subnet_id                   = module.my_vpc.public_subnets[0]
  associate_public_ip_address = true
  create_security_group       = false
  vpc_security_group_ids      = [module.my_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ssm.name

  user_data = file("${path.module}/userdata.sh")

  tags = { Name = "tf-rackula-server" }

  depends_on = [aws_iam_role_policy_attachment.ssm]
}
