# Workload Identity for Cloud SQL Access on GKE

This document describes how to configure Workload Identity so that pods in your Kubernetes cluster can access a private Cloud SQL instance without using static service account keys. The process is fully automated using Terraform.

## Overview

We will set up the following:
- A **Kubernetes Service Account (KSA)** in the `odi-dev` namespace.
- A **Google IAM Service Account (GSA)** for Cloud SQL access.
- IAM policy bindings to grant the necessary Cloud SQL permissions to the GSA.
- An IAM binding that allows the KSA to impersonate the GSA (Workload Identity binding).
- Annotation of the KSA with the GSA email.
- Configuration of your Cloud SQL instance and GKE cluster to use Workload Identity.

## Prerequisites

- **Terraform** installed (v0.14+ recommended).
- **gcloud CLI** installed and authenticated.
- A working **GKE cluster**.
- The `odi-dev` namespace created in your Kubernetes cluster.
- Required IAM permissions to create service accounts and assign roles in your project.

## Directory Structure

Below is an example structure for our Terraform configuration:


## Terraform Configuration

### 1. Create a Kubernetes Service Account (KSA)

In your workload-identity module (or directly in your root configuration), create a Kubernetes service account in the `odi-dev` namespace and annotate it with the GSA email.

```hcl
resource "kubernetes_service_account" "cloudsql_ksa" {
  metadata {
    name      = "odi-dev-cloudsql-ksa"
    namespace = "odi-dev"
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.cloudsql.email
    }
  }
}

resource "google_service_account" "cloudsql" {
  account_id   = "odi-dev-cloudsql-gsa"
  display_name = "GSA for Kubernetes to access Cloud SQL via Workload Identity"
  project      = var.project_id
}

resource "google_project_iam_member" "cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloudsql.email}"
}
resource "google_service_account_iam_member" "cloudsql_ksa_binding" {
  service_account_id = google_service_account.cloudsql.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[odi-dev/odi-dev-cloudsql-ksa]"
}
```

Deploy a Test Pod:
apiVersion: v1
kind: Pod
metadata:
  name: cloudsql-test
  namespace: odi-dev
spec:
  serviceAccountName: odi-dev-cloudsql-ksa
  containers:
  - name: test-container
    image: gcr.io/google.com/cloudsdktool/cloud-sdk:slim
    command: ["/bin/sh", "-c", "while true; do sleep 30; done"]
