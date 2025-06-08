resource "ionoscloud_k8s_node_pool" "example" {
  datacenter_id  = var.datacenter_id
  k8s_cluster_id = ionoscloud_k8s_cluster.example.id
  name           = "k8sNodePool"
  k8s_version    = ionoscloud_k8s_cluster.example.k8s_version
  maintenance_window {
    day_of_the_week = "Monday"
    time            = "09:00:00Z"
  }
  cpu_family        = "INTEL_SKYLAKE"
  availability_zone = "AUTO"
  storage_type      = "SSD"
  node_count        = var.node_count > 4 ? 4 : var.node_count
  cores_count       = 8
  ram_size          = 30720
  storage_size      = 100
}
