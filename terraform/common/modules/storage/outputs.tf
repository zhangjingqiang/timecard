output bucket_access_logs_source {
  value = google_storage_bucket.access_logs_source
}

output bucket_action_logs_source {
  value = google_storage_bucket.action_logs_source
}

output bucket_access_logs_success {
  value = google_storage_bucket.access_logs_success
}

output bucket_action_logs_success {
  value = google_storage_bucket.action_logs_success
}

output bucket_access_logs_error {
  value = google_storage_bucket.access_logs_error
}

output bucket_action_logs_error {
  value = google_storage_bucket.action_logs_error
}
