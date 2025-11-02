terraform {
  backend "s3" {
    bucket = "terraform-statefile-backup-v5"
    key    = "key/terraform.tfstate"
    use_lockfile = true
    region = "us-east-1"
  }
}