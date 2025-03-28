# VPC variables
variable "project_id" {}
variable "region" {}
variable "vpc_name" {}
variable "create_subnetworks" {
  default = false
}
# variable "create_new_network" {
#   default = true
# }
variable "network_routing_mode" {
  default = "GLOBAL"
}

