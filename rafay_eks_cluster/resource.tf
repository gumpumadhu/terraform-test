resource "rafay_eks_cluster" "cluster" {
  name         = var.name
  projectname  = var.project
  yamlfilepath = var.yamlfilepath
  yamlfileversion = ""
}

resource "null_resource" "cluster" {
  provisioner "local-exec" {
    command = <<-EOT
      chmod +x check_cluster_status.sh
      ./check_cluster_status.sh
    EOT
  }
}
