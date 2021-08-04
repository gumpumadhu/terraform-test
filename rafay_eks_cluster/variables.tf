variable "name" {
  description = "name to pass to cluster name tag"
  default = "rauto-infra-provisioner"
}

variable "yamlfilepath" {
  description = "path to cluster yaml file"
  default = "eks-cluster.yaml"
}

variable "project" {
  description = "project to pass to project tag"
  default = "defaultproject"
}
