module "my_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 6.0"

  name            = "tf-rackula-sg"
  use_name_prefix = false
  vpc_id          = module.my_vpc.vpc_id

  # Rackula web UI is published on port 8080. The persistence API on
  # port 3001 is only reachable inside the Docker Compose network.
  ingress_rules = {
    rackula_http = {
      description = "Rackula web UI"
      cidr_ipv4   = "0.0.0.0/0"
      ip_protocol = "tcp"
      from_port   = 8080
      to_port     = 8080
    }
  }

  egress_rules = {
    all = { cidr_ipv4 = "0.0.0.0/0", ip_protocol = "-1" }
  }

  tags = { Name = "tf-rackula-sg" }
}
