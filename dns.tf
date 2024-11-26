resource "google_dns_managed_zone" "beta-meltphace-org" {
  name        = "beta-meltphace-org"
  dns_name    = "beta.meltphace.org."
  description = "beta DNS zone"
}