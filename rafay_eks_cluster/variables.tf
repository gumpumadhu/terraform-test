variable "name" {
  description = "name to pass to cluster name tag"
  type = string
  default = "rauto-infra-provisioner"
}

variable "yamlfilepath" {
  description = "path to cluster yaml file"
  type = string
  default = "eks-cluster.yaml"
}

variable "project" {
  description = "project to pass to project tag"
  type = string
  default = "defaultproject"
}
