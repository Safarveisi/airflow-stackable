variable "datacenter_id" {
  description = "Datacenter UUID"
  type        = string
  sensitive   = true
}

variable "cluster_name" {
  description = "K8s Cluster name"
  type        = string
}

variable "k8s_version" {
  description = "Version of the K8s cluster"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the K8s cluster"
  type        = number
}
