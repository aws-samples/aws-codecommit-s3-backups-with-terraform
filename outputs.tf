output "bucket" {
  value = aws_s3_bucket.this
}

output "cwl_group" {
  value = aws_cloudwatch_log_group.this
}

output "codebuild_project" {
  value = aws_codebuild_project.this
}
