output "bucket_url" {
  value       = google_storage_bucket.code_bucket.url
  description = "The URL of the source bucket"
}

output "http_trigger_url" {
  value       = google_cloudfunctions_function.function.https_trigger_url
  description = "URL which triggers function execution"
}
