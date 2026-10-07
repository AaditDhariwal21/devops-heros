# ---------- lookups (data sources read things, they don't create anything) ----------

data "aws_availability_zones" "available" {
  state = "available"
}

# latest Amazon Linux 2023 image
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# ---------- network ----------

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags                 = { Name = "${var.project}-vpc" }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id # implicit dependency: vpc gets created first
  tags   = { Name = "${var.project}-igw" }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.project}-public" }
}

# private subnet - no route to the internet (no NAT gateway, those cost money)
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  tags              = { Name = "${var.project}-private" }
}

# this route is what makes the public subnet "public"
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = { Name = "${var.project}-public-rt" }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ---------- security group: only http in, anything out ----------

resource "aws_security_group" "web" {
  name        = "${var.project}-web-sg"
  description = "allow http from anywhere"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project}-web-sg" }
}

# ---------- ec2 running nginx ----------

resource "aws_instance" "web" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]

  # runs once on first boot
  user_data = <<-EOT
    #!/bin/bash
    dnf install -y nginx
    echo "<h1>Hello from Terraform - session 19</h1><p>Server: $(hostname)</p>" > /usr/share/nginx/html/index.html
    systemctl enable --now nginx
  EOT

  # explicit dependency: the box needs the internet (dnf install) as soon as it boots,
  # and nothing in this block references the route table, so tell terraform directly
  depends_on = [aws_route_table_association.public]

  tags = { Name = "${var.project}-web" }
}

# ---------- s3 ----------

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "assets" {
  bucket        = "${var.project}-assets-${random_id.suffix.hex}"
  force_destroy = true
  tags          = { Name = "${var.project}-assets" }
}

resource "aws_s3_bucket_public_access_block" "assets" {
  bucket                  = aws_s3_bucket.assets.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "info" {
  bucket       = aws_s3_bucket.assets.id
  key          = "server-info.txt"
  content      = "web server ${aws_instance.web.id} is in subnet ${aws_subnet.public.id} (vpc ${aws_vpc.main.id})\n"
  content_type = "text/plain"
}
