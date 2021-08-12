resource "rafay_eks_cluster" "cluster" {
  name         = var.name
  projectname  = var.project
  yamlfilepath = var.yamlfilepath
}

resource "null_resource" "cluster" {
  provisioner "file" {
    source      = "rafay_eks.sh"
    destination = "/home/ubuntu/rafay_eks.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/rafay_eks.sh",
      "bash -x /home/ubuntu/rafay_eks.sh",
    ]
  }
}
