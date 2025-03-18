module "vpc" {
  source       = "../kareco-modules/vpc"
  project_id   = var.project_id
  network_name = var.network_name.name
  region       = var.region
  subnet_cidr = var.subnet_cidr
 
}

module "firewall_rules" {
  source            = "../kareco-modules/firewall-rules"
  project_id        = var.project_id
  network_name = module.vpc.network_name.name
  source_ranges     = ["0.0.0.0/0"]
}
