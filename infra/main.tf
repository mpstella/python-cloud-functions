provider "google" {
  project = var.project
}

terraform {
  backend "local" {}
}

module "cloud_function_http_trigger" {
  source      = "./modules/cloud-functions-http"
  project     = var.project
  region      = var.region
  src_bucket  = "mtdg-src-code-bucket"
  src_path    = "${path.root}/../src"
  entry_point = "hello_http"
  name        = "function-test"
  description = "Hello-World"
}
