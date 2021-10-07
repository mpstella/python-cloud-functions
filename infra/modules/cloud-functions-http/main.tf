locals {
  now          = formatdate("YYYYMMDD_hhmmss", timestamp())
  zip_filename = "${var.name}-${local.now}.zip"
  output_path  = "${var.output_dir}/${local.zip_filename}"
  bucket_name  = var.src_bucket != "" ? var.src_bucket : "${var.project}-src-code"
}

resource "google_project_service" "cloudfunctions" {
  project = var.project
  service = "cloudfunctions.googleapis.com"

  disable_dependent_services = true
  disable_on_destroy         = false
}

resource "google_project_service" "cloudbuild" {
  project = var.project
  service = "cloudbuild.googleapis.com"

  disable_dependent_services = true
  disable_on_destroy         = false
}

data "archive_file" "python_source" {
  type        = "zip"
  source_dir  = var.src_path
  output_path = local.output_path
}

resource "google_storage_bucket" "code_bucket" {
  name                        = local.bucket_name
  location                    = var.region
  project                     = var.project
  storage_class               = var.storage_class
  uniform_bucket_level_access = var.uniform_bucket_level_access
  labels                      = var.labels
}

resource "google_storage_bucket_object" "archive" {
  name   = "${var.name}/${basename(data.archive_file.python_source.output_path)}"
  bucket = google_storage_bucket.code_bucket.name
  source = data.archive_file.python_source.output_path
}

resource "google_cloudfunctions_function" "function" {
  name        = var.name
  description = var.description
  runtime     = var.runtime
  project     = var.project
  region      = var.region

  available_memory_mb   = var.available_memory_mb
  source_archive_bucket = google_storage_bucket.code_bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  entry_point           = var.entry_point

  depends_on = [
    google_project_service.cloudfunctions,
    google_project_service.cloudbuild
  ]
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = var.project
  region         = var.region
  cloud_function = var.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"

  depends_on = [
    google_cloudfunctions_function.function
  ]
}
