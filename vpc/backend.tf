terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "/key/terraform.tfstate"
    use_lockfile = true
    region = "us-east-1"
  }
}