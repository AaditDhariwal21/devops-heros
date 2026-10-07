output "bucket_name" {
  value = aws_s3_bucket.demo.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.demo.arn
}

output "bucket_region" {
  value = aws_s3_bucket.demo.region
}

output "object_url" {
  description = "won't open in a browser - bucket is private"
  value       = "s3://${aws_s3_bucket.demo.bucket}/${aws_s3_object.hello.key}"
}
