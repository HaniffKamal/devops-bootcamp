module "my_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.7"

  name = "tf-rackula-vpc"
  cidr = "10.40.0.0/16"
  azs  = ["ap-southeast-1a"]

  public_subnets = ["10.40.1.0/24"]

  map_public_ip_on_launch = true

  tags = {
    Name = "tf-rackula-vpc"
  }
}
