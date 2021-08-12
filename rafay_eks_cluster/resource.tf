resource "rafay_eks_cluster" "cluster" {
  name         = var.name
  projectname  = var.project
  yamlfilepath = var.yamlfilepath
}

resource "null_resource" "cluster" {
  provisioner "local-exec" {
    command = <<-EOT
      chmod +x rafay_eks.sh
      ./rafay_eks.sh
    EOT
  }
}
