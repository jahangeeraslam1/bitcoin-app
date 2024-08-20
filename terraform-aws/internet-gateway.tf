
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mainVPC.id #attach the internet gateway to the VPC previosuly created


  tags = {
    Name = "${local.env}-igw"
  }
}