########################################
#### DNS Zone and Managed TLS Cert #####
########################################

resource "google_dns_managed_zone" "beta-meltphace-org" {
  name        = "beta-meltphace-org"
  dns_name    = "beta.meltphace.org."
  description = "beta DNS zone"
}

# resource "google_certificate_manager_certificate" "default" {
#   name        = "dns-cert-${google_dns_managed_zone.beta-meltphace-org.name}"
#   description = "Default cert"
#   managed {
#     domains = [
#       trim(google_dns_managed_zone.beta-meltphace-org.dns_name, ".")
#       ]
#     dns_authorizations = [
#       google_certificate_manager_dns_authorization.default.id,
#       ]
#   }
#   depends_on = [ google_dns_record_set.authorization ]
# }

# resource "google_certificate_manager_certificate_map" "default" {
#   name        = "certmap-beta-meltphace-org"
#   description = "beta.meltphace.org certificate map"
# }

# # resource "google_certificate_manager_certificate_map_entry" "default" {
# #   name        = "cert-entry-certmap-beta-meltphace-org"
# #   description = "example certificate map entry"
# #   map         = google_certificate_manager_certificate_map.default.name
# #   certificates = [google_certificate_manager_certificate.default.id]
# #   hostname     = trim(google_dns_managed_zone.beta-meltphace-org.dns_name, ".")
# # }

# resource "google_certificate_manager_dns_authorization" "default" {
#   name      = "dns-auth"
#   location  = "global"
#   type      = "FIXED_RECORD"
#   domain    = trim(google_dns_managed_zone.beta-meltphace-org.dns_name, ".")
# }

# resource "google_dns_record_set" "authorization" {
#   managed_zone = google_dns_managed_zone.beta-meltphace-org.name
#   name         = google_certificate_manager_dns_authorization.default.dns_resource_record.0.name
#   type         = google_certificate_manager_dns_authorization.default.dns_resource_record.0.type
#   rrdatas = [google_certificate_manager_dns_authorization.default.dns_resource_record.0.data]
# }

# resource "google_dns_record_set" "lb" {
#   managed_zone = google_dns_managed_zone.beta-meltphace-org.name
#   name         = google_dns_managed_zone.beta-meltphace-org.dns_name
#   type         = "A"
#   rrdatas = [google_compute_global_address.default.address]
# }

###################################
#### Storage and Load Balancer ####
###################################

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

# # Make bucket public
# resource "google_storage_bucket_iam_member" "static-site" {
#   bucket = google_storage_bucket.static-site.name
#   role   = "roles/storage.objectViewer"
#   member = "allUsers"
# }

# # IP address (cause I guess this is the only sane way to point DNS at an external LB?)
# resource "google_compute_global_address" "default" {
#   name = "magic-internet-number"
# }

# resource "google_compute_backend_bucket" "static-site" {
#   name        = "compute-backend-bucket-beta"
#   bucket_name = google_storage_bucket.static-site.name
# }

# resource "google_compute_url_map" "default" {
#   name = "http-lb"

#   default_service = google_compute_backend_bucket.static-site.id

#   host_rule {
#     hosts        = ["*"]
#     path_matcher = "all-paths"
#   }

#   path_matcher {
#     name            = "all-paths"
#     default_service = google_compute_backend_bucket.static-site.id

#     # path_rule {
#     #   paths   = ["/love-to-fetch/*"]
#     #   service = google_compute_backend_bucket.bucket_2.id
#     # }
#   }
# }

# resource "google_compute_target_https_proxy" "default" {
#   name             = "beta-proxy"
#   url_map          = google_compute_url_map.default.id
#   certificate_map  = "//certificatemanager.googleapis.com/${google_certificate_manager_certificate_map.default.id}"
# }

# resource "google_compute_global_forwarding_rule" "default" {
#   name                  = "https-proxy-forwarding-rule"
#   provider              = google
#   ip_protocol           = "TCP"
#   load_balancing_scheme = "EXTERNAL"
#   port_range            = "443"
#   target                = google_compute_target_https_proxy.default.id
#   ip_address            = google_compute_global_address.default.id
# }