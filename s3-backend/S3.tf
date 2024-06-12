resource "aws_s3_bucket" "backend_bucket" {
  bucket = "backend-bucket119298307439258"
}

resource "aws_s3_bucket_acl" "backend_bucket_acl" {
  bucket = aws_s3_bucket.backend_bucket.id
  acl = "private"
}