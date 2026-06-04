terraform {
  backend "s3" {
    bucket       = "cloud-mastery-tfstate-bucket-677920913262"
    key          = "production-full-app/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
