resource "aws_route_table" "private" {
  vpc_id = aws_vpc.mainVPC.id

  route {
    cidr_block     = "0.0.0.0/0" #if no other routes match the request this will be used
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${local.env}-private_route_table"
  }

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.mainVPC.id

  route {
    cidr_block = "0.0.0.0/0" #if no other routes match the request this will be used
    gateway_id = aws_internet_gateway.igw.id

  }

  tags = {
    Name = "${local.env}-public_route_table"
  }
}

resource "aws_route_table_association" "private_zone1" {
  subnet_id      = aws_subnet.private_zone1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_zone2" {
  subnet_id      = aws_subnet.private_zone2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public_zone1" {
  subnet_id      = aws_subnet.public_zone1.id
  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "public_zone2" {
  subnet_id      = aws_subnet.public_zone2.id
  route_table_id = aws_route_table.public.id

}