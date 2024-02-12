data "aws_subnets" "private" {
  depends_on = [
    aws_subnet.private
  ]
  filter {
    name   = "tag:tier"
    values = ["private"]
  }
}
data "aws_availability_zones" "available" {
}