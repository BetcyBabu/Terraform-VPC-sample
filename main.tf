# =====================================================
# vpc Creation
# =====================================================

resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project}-vpc"
  }
}

# =====================================================
# Attaching Internet gateWay
# =====================================================

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-igw"
  }
}

# =====================================================
# Creating Subnets Public 1
# =====================================================

resource "aws_subnet" "public01" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block_pub01
  availability_zone = var.AZ_pub01
  map_public_ip_on_launch = true


  tags = {
    Name = "${var.project}-public01"
  }
}

# =====================================================
# Creating Subnets Public 2
# =====================================================

resource "aws_subnet" "public02" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block_pub02
  availability_zone = var.AZ_pub02
  map_public_ip_on_launch = true


  tags = {
    Name = "${var.project}-public02"
  }
}


# =====================================================
# Creating Subnets Public 3
# =====================================================

resource "aws_subnet" "public03" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block_pub03
  availability_zone = var.AZ_pub03
  map_public_ip_on_launch = true


  tags = {
    Name = "${var.project}-public03"
  }
}

# =====================================================
# Creating Subnets Private 1
# =====================================================

resource "aws_subnet" "private01" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block_pri01
  availability_zone = var.AZ_pri01


  tags = {
    Name = "${var.project}-private01"
  }
}

# =====================================================
# Creating Subnets Private 2
# =====================================================


resource "aws_subnet" "private02" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block_pri02
  availability_zone = var.AZ_pri02


  tags = {
    Name = "${var.project}-private02"
  }
}

# =====================================================
# Creating Subnets Private 3
# =====================================================

resource "aws_subnet" "private03" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block_pri03
  availability_zone = var.AZ_pri03



  tags = {
    Name = "${var.project}-private03"
  }
}

# =====================================================
# Elatic Ip Allocation
# =====================================================

resource "aws_eip" "eip" {
  vpc      = true

  tags = {
    Name = "${var.project}-eip"
  }

}

# =====================================================
# Creating Nat GateWay
# =====================================================

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public03.id

  tags = {
    Name = "${var.project}-natgw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

# =====================================================
# RouteTable Creation public
# =====================================================

resource "aws_route_table" "rtbldefault" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.project}-rtbldefault"
  }
  
}

# =====================================================
# RouteTable Creation Private
# =====================================================

resource "aws_route_table" "rtblnat" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "${var.project}-rtblnat"
  }
  
}

# =====================================================
# RouteTable Association subnet Public 1  rtb public
# =====================================================

resource "aws_route_table_association" "public01" {
  subnet_id      = aws_subnet.public01.id
  route_table_id = aws_route_table.rtbldefault.id
}

# =====================================================
# RouteTable Association subnet Public2  rtb public
# =====================================================

resource "aws_route_table_association" "public02" {
  subnet_id      = aws_subnet.public02.id
  route_table_id = aws_route_table.rtbldefault.id
}

# =====================================================
# RouteTable Association subnet Public3  rtb public
# =====================================================

resource "aws_route_table_association" "public03" {
  subnet_id      = aws_subnet.public03.id
  route_table_id = aws_route_table.rtbldefault.id
}

# =====================================================
# RouteTable Association subnet Private1  rtb private
# =====================================================

resource "aws_route_table_association" "private01" {
  subnet_id      = aws_subnet.private01.id
  route_table_id = aws_route_table.rtblnat.id
}
# =====================================================
# RouteTable Association subnet private2  rtb private
# =====================================================

resource "aws_route_table_association" "private02" {
  subnet_id      = aws_subnet.private02.id
  route_table_id = aws_route_table.rtblnat.id
}

# =====================================================
# RouteTable Association subnet private3  rtb private
# =====================================================

resource "aws_route_table_association" "private03" {
  subnet_id      = aws_subnet.private03.id
  route_table_id = aws_route_table.rtblnat.id
}