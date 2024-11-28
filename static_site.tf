
resource "google_storage_bucket" "static-site" {
  name          = "beta.meltphace.org"
  location      = "US-EAST4"
  force_destroy = true

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_dns_managed_zone" "beta-meltphace-org" {
  name        = "beta-meltphace-org"
  dns_name    = "beta.meltphace.org."
  description = "beta DNS zone"
}


# resource "google_dns_record_set" "test" {
#   name = "test.${google_dns_managed_zone.beta-meltphace-org.dns_name}"
#   type = "TXT"
#   ttl  = 300

#   managed_zone = google_dns_managed_zone.beta-meltphace-org.name

#   rrdatas = ["Record Test"]
# }

