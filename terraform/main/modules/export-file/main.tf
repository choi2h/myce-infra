locals {
  export_ips = {
    PUBLIC_IP  = var.public_ip
    NAT_GW_IP     = var.nat_ip
    BASTION_IP = var.bastion_ip
    PRIVATE_IP = var.private_ip
  }

  export_ips_yml = yamlencode(local.export_ips)
}

data "aws_s3_bucket" "artifact" {
  bucket = var.artifact_bucket
}

resource "aws_s3_object" "export_ips_yml_file" {
  bucket = data.aws_s3_bucket.artifact.id
  key = var.artifact_export_path
  content = local.export_ips_yml
  content_type = "application/x-yaml"
}