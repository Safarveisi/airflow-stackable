variable "ionos_token" {
  description = "IONOS cloud token"
  type        = string
  sensitive   = true
}

variable "datacenter_id" {
  description = "Datacenter UUID"
  type        = string
  sensitive   = true
}
