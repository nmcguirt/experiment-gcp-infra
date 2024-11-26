provider "google" {
  region  = "us-east4"
  project = "github-exploration-442503"
}

terraform {
  backend "gcs" {}
}

