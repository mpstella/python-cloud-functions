variable "project" {
  description = "The GCP project"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "labels" {
  description = "(Optional) labels to apply to the resources"
  type        = map(string)
  default     = {}
}

variable "src_bucket" {
  description = "The name of the bucket to hold the source code (zipped)"
  type        = string
}

variable "storage_class" {
  description = "(Optional) Storage class for the bucket"
  type        = string
  default     = "STANDARD"
}

variable "uniform_bucket_level_access" {
  description = "(Optional) Access for the bucket"
  type        = bool
  default     = true
}

variable "src_path" {
  description = "Path to source directory"
  type        = string
}

variable "output_path" {
  description = "(Optional) path to final archive file"
  type        = string
  default     = ""
}

variable "runtime" {
  description = "(Optional) runtime of the function"
  type        = string
  default     = "python39"
}

variable "entry_point" {
  description = "Entry point to the cloud function"
  type        = string
}

variable "name" {
  description = "Name of the cloud function"
  type        = string
}

variable "description" {
  description = "(Optional) Description of the function"
  type        = string
  default     = ""
}
