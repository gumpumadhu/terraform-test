resource "rafay_eks_cluster" "cluster" {
  name         = var.name
  projectname  = var.project
  yamlfilepath = var.yamlfilepath
}

resource "null_resource" "cluster" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash","-c"]
    command = "./rafay_eks.sh" 
  }
}
