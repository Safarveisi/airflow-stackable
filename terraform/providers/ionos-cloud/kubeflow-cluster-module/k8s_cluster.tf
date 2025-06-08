resource "ionoscloud_k8s_cluster" "example" {
  name        = var.cluster_name
  k8s_version = var.k8s_version
  maintenance_window {
    day_of_the_week = "Sunday"
    time            = "09:00:00Z"
  }
}
