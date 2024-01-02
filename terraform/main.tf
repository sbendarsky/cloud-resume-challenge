# Create S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucketname
  tags = {
    Name = "cloud-resume-project"
  }
}

resource "aws_s3_bucket_public_access_block" "my_bucket" {
  bucket = aws_s3_bucket.my_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "index.html"
  source = "../web/index.html"
  acl   = "private"
  content_type = "text/html"
}

resource "aws_s3_object" "favicon" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "favicon.ico"
  source = "../web/favicon.ico"
  acl   = "private"
  content_type = "image/x-icon"
}

resource "aws_s3_object" "style" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "style.css"
  source = "../web/style.css"
  acl   = "private"
  content_type = "text/css"
}

resource "aws_s3_object" "script" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "script.js"
  source = "../web/script.js"
  acl   = "private"
  content_type = "text/javascript"
}

locals {
  s3_origin_id = "S3-${aws_s3_bucket.my_bucket.id}"
}

resource "aws_cloudfront_origin_access_identity" "example" {
  comment = "Some comment"
}

resource "aws_iam_user" "cloudfront_dummy_user" {
  name = "cloudfront_dummy_user"
}

resource "aws_iam_access_key" "cloudfront_dummy_user_key" {
  user = aws_iam_user.cloudfront_dummy_user.name
}

resource "aws_iam_role" "cloudfront_s3_access_role" {
  name = "CloudFrontS3AccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "cloudfront_s3_access_attachment" {
  policy_arn = aws_iam_policy.cloudfront_s3_access_policy.arn
  role       = aws_iam_role.cloudfront_s3_access_role.name
}

resource "aws_iam_policy" "cloudfront_s3_access_policy" {
  name        = "CloudFrontS3AccessPolicy"
  description = "IAM policy for CloudFront to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:GetObject"],
        Resource = ["${aws_s3_bucket.my_bucket.arn}/*"],
      },
    ],
  })
}



# Create CloudFront Distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.my_bucket.bucket_regional_domain_name
    origin_id                = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.example.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "My CloudFront Distribution"
  default_root_object = "index.html"

  aliases = ["terraform.sbendarsky.me"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
        restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:489653259257:certificate/fc66b5a8-c082-4e10-b2ec-a5b1e6ab0710"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

  tags = {
    Environment = "production"
  }

  depends_on = [
    aws_iam_role_policy_attachment.cloudfront_s3_access_attachment,
  ]
}
