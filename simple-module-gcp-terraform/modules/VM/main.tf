resource "google_compute_instance" "bastion_host" {
  name         = var.instance_name 
  machine_type = var.instance_machine_type 
  zone         = var.instance_zone 

  boot_disk {
    initialize_params {
      image = var.instance_image 
    }
  }

  network_interface {
    subnetwork = var.subnet_01_name # "projects/YOUR_PROJECT_ID/regions/africa-south1/subnetworks/odi-dev-vpc-subnet-01"
    access_config {} # This can be removed if you want a private VM with no external IP
  }

  tags = ["bastion"]

  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt-get update
    wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
    sudo dpkg -i cloudflared-linux-amd64.deb
    sudo cloudflared service install eyJhIjoiMjRmYjcwMWY1ZWU5OWI5YTk3ODM1NTM2OWUwZTM2YjIiLCJ0IjoiYTdkNWZlNTYtNDAwYy00Y2QzLTg5MTItYTM0ODUyYTYxMjFjIiwicyI6IlptUTVaakU1TTJZdE16aGpZaTAwTnpJd0xXSTBabVV0T0RRek9EWmlZekkxWlRBNSJ9
    sudo apt-get install kubectl
    sudo apt-get install google-cloud-cli-gke-gcloud-auth-plugin
  EOT
}
