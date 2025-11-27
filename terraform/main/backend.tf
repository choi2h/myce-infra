terraform {
    backend "s3" {
        bucket = var.state_s3_name
        key = "./terraform.tfstate"
        region = var.aws_region
        encrypt = true
        dynamodb_table = var.state_dynamodb_name
    }
}