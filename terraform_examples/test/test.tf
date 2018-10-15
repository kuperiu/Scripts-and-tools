data "aws_availability_zones" "available" {}

output "region" {
    value = "${data.aws_availability_zones.available.names}"
    
}