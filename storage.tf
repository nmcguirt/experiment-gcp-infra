resource "google_storage_bucket" "static-site" {
  name          = "beta.meltphace.org"
  location      = "us-east-4"
  force_destroy = true

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}