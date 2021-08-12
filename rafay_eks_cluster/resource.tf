resource "rafay_eks_cluster" "cluster" {
  name         = var.name
  projectname  = var.project
  yamlfilepath = var.yamlfilepath
}

