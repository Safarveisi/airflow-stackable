terraform {
  required_providers {
    ionoscloud = {
      source  = "ionos-cloud/ionoscloud"
      version = ">= 6.4.10"
    }
  }
}

provider "ionoscloud" {
  # For this authorization to work, environment variable TF_VAR_ionos_token must be available
  token = "${var.ionos_token}"
}

locals {
  environment_name = "production"
  node_count = 4
}

module "kubeflow_cluster_1" {
  source = "../../kubeflow-cluster-module"

  datacenter_id = "${var.datacenter_id}"
  cluster_name  = "k8s-stackable-${local.environment_name}"
  k8s_version   = "1.31.3"
  node_count    = local.node_count
}
