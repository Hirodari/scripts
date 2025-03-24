# VPC
variable "project_id" {}
variable "region" {}
variable "vpc_id" {}

# Subnets
variable "subnet_01_cidr" {}
variable "subnet_02_cidr" {}
variable "subnet_01_pods_cidr" {}
variable "subnet_01_svc_cidr" {}
variable "subnet_02_pods_cidr" {}
variable "subnet_02_svc_cidr" {}
variable "vpc_name" {}
locals {
  gke_pods_range_name = "ip-range-pods"
  gke_svc_range_name  = "ip-range-svc"

}

