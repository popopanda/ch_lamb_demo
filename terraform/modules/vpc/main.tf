resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr_block}"
  instance_tenancy     = "default"
  enable_dns_support   = "${var.enable_dns_support}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"

  tags {
    Name        = "${var.environment}-vpc"
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "public" {
  count                   = "${length(var.zone)}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${element(var.public_cidr_block, count.index)}"
  availability_zone       = "us-east-1${element(var.zone, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name        = "${var.environment}-public-${count.index}"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "private" {
  count             = "${length(var.zone)}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${element(var.private_cidr_block, count.index)}"
  availability_zone = "us-east-1${element(var.zone, count.index)}"

  tags {
    Name        = "${var.environment}-private-${count.index}"
    Environment = "${var.environment}"
  }
}

# Public route
resource "aws_route_table" "public_route" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "${var.environment}-public-route-${count.index}"
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "public_rtable" {
  count          = "${length(var.zone)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_route.id}"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "${var.environment}-gw-${count.index}"
    Environment = "${var.environment}"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = "${aws_route_table.public_route.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
  depends_on             = ["aws_route_table.public_route"]
}

# Private route
resource "aws_route_table" "private_route" {
  count  = "${length(var.zone)}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "${var.environment}-private-route-${count.index}"
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# This costs money

resource "aws_eip" "nat_eip" {
  count = "${length(var.zone)}"
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "private_nat_gw" {
  count         = "${length(var.zone)}"
  allocation_id = "${element(aws_eip.nat_eip.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "private_route_assoc" {
  count          = "${length(var.zone)}"
  subnet_id      = "${element(aws_subnet.private.*.id,count.index)}"
  route_table_id = "${element(aws_route_table.private_route.*.id,count.index)}"
}

resource "aws_route" "private_internet" {
  count                  = "${length(var.zone)}"
  route_table_id         = "${element(aws_route_table.private_route.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.private_nat_gw.*.id, count.index)}"
  depends_on             = ["aws_route_table.private_route"]
}

# Security security group
resource "aws_security_group" "permit_env" {
  name        = "permit env"
  description = "allow resources to vpc to talk"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    self      = true
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
