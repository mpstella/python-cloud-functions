locals {
    project = "mtdg-gcp-go-test-sandpit"
    region  = "australia-southeast1"
}

provider "google" {
  project = local.project
  region = local.region
}

terraform {
  backend "local" {}
}

resource "google_cloudfunctions_function" "function" {
  name                  = "func-test2"
  description           = "Testing out Update function"
  runtime               = "python39"
  available_memory_mb   = 128
  source_archive_bucket = "mtdg-gcp-go-test-sandpit-src-code"
  source_archive_object = "function-test/function-test-20211007_060504.zip"
  trigger_http          = true
  entry_point           = "hello_http"
}