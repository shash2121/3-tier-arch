###########
# VPC
###########
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.vpc_tenancy

  tags = merge(
   {
    Name = "${var.ENV}-vpc"
  },
  var.tags
  )
}

####################
## Internet Gateway
####################

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.ENV}-igw"
  }
}


##########
# Subnets:- creating three public subnets and three private subnets
##########
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  count     = length(local.pvt_subnet_list)
  cidr_block = local.pvt_subnet_list[count.index]
  map_public_ip_on_launch = false
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = merge(
  {
    Name = "${var.ENV}.private-subnet-${count.index+1}"
    Environment = var.ENV
    tier = "private"
  },
  var.tags
)
}

resource "aws_subnet" "public" {
   vpc_id     = aws_vpc.main.id
   count      = length(local.pub_subnet)
   cidr_block = local.pub_subnet[count.index]
   map_public_ip_on_launch = true
   availability_zone = element(data.aws_availability_zones.available.names, count.index)

   tags = merge(
  {
    Name = "${var.ENV}.public-subnet-${count.index+1}"
    Environment = var.ENV
  },
  var.tags
)
}

###############
## NAT Gateway
###############
resource "aws_eip" "main" {
  vpc = true
}
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.ENV}-ngw"
  }
}


############## Route Table ############################
resource "aws_route_table" "ngw" {
  vpc_id = aws_vpc.main.id

  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.main.id
    }
}

resource "aws_route_table" "igw" {
  vpc_id = aws_vpc.main.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.main.id
    }
}

############################
## Route Table Associations
############################

resource "aws_route_table_association" "a" {
  count     = length(local.pvt_subnet_list)
  depends_on = [
    aws_subnet.private
  ]
  subnet_id      = (tolist(data.aws_subnets.private.ids))[count.index]
  route_table_id = aws_route_table.ngw.id

}

resource "aws_main_route_table_association" "b" {
  vpc_id = aws_vpc.main.id
  depends_on = [
    aws_subnet.public
  ]
  #subnet_id     = aws_subnet.public[*].id
  route_table_id = aws_route_table.igw.id
}