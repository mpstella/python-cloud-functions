
resource "google_project_service" "cloudfunctions" {
  project = var.project
  service = "cloudfunctions.googleapis.com"
}

resource "google_project_service" "cloudbuild" {
  project = var.project
  service = "cloudbuild.googleapis.com"
}

data "archive_file" "python_source" {
  type        = "zip"
  source_dir  = var.src_path
  output_path = var.output_path != "" ? var.output_path : "${var.src_path}.zip"
}

resource "google_storage_bucket" "code_bucket" {
  name                        = var.src_bucket != "" ? var.src_bucket : "${var.project}-src-code"
  location                    = var.region
  project                     = var.project
  storage_class               = var.storage_class
  uniform_bucket_level_access = var.uniform_bucket_level_access
  labels                      = var.labels
}

resource "google_storage_bucket_object" "archive" {
  name   = var.src_archive_name != "" ? var.src_archive_name : basename(data.archive_file.python_source.output_path)
  bucket = google_storage_bucket.code_bucket.name
  source = data.archive_file.python_source.output_path
}

resource "google_cloudfunctions_function" "function" {
  name        = var.name
  description = var.description
  runtime     = var.runtime
  project     = var.project
  region      = var.region

  available_memory_mb   = 128
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
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
