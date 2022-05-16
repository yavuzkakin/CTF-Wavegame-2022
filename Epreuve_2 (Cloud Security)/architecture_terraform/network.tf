
################################################# CN2 #######################################""
resource "aws_vpc" "prod-main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "prod-main"
  }
}

resource "aws_subnet" "prod-subnet-public" {
  vpc_id     = aws_vpc.prod-main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    "exposition"="public"
  }
}

resource "aws_subnet" "prod-subnet-private" {
  vpc_id     = aws_vpc.prod-main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    "exposition"="private"
  }
}

resource "aws_internet_gateway" "gw"{
  vpc_id = aws_vpc.prod-main.id
}

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.prod-main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public-filter-association" {
  subnet_id      = aws_subnet.prod-subnet-public.id # On associe uniquement les subnets publics à la table de routage
  route_table_id = aws_route_table.route-table.id
}

###################################### CN3 #############################################################
resource "aws_security_group" "allow_web" { #Allow acess to all but administrative ports
  name        = "allow_web"
  description = "Allow inbound traffic rules"
  vpc_id      = aws_vpc.prod-main.id

  ingress {
    description      = "Allowing all but sensitive ports"
    from_port        = 0
    to_port          = 21
    protocol         = "tcp" 
    cidr_blocks      = ["0.0.0.0/0"] #any IP source
  }

  ingress {
    description      = "Allowing all but sensitive ports"
    from_port        = 23
    to_port          = 3388
    protocol         = "tcp" 
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  ingress {
    description      = "Allowing all but sensitive ports"
    from_port        = 3390
    to_port          = 65535
    protocol         = "tcp" 
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "web-server-noops" {
  subnet_id       = aws_subnet.prod-subnet-public.id
  private_ips     = ["10.0.1.50"] #assign private IPs, we can give more than one
  security_groups = [aws_security_group.allow_web.id]
}

resource "aws_eip" "one" {
  network_interface = aws_network_interface.web-server-noops.id
  associate_with_private_ip = "10.0.1.50"
  vpc      = true
}