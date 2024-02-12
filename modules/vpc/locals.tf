locals {
  pvt_subnet_list = [cidrsubnets(var.vpc_cidr, 8,1)[1],
                  cidrsubnets(var.vpc_cidr, 8,2)[1],
                  cidrsubnets(var.vpc_cidr, 8,3)[1]
  ]
  pub_subnet = [cidrsubnets(var.vpc_cidr, 8,4)[1],
                cidrsubnets(var.vpc_cidr, 8,5)[1],
                cidrsubnets(var.vpc_cidr, 8,6)[1]
      ] 
}