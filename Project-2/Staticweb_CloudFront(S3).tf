##---AWS_Access_Part---##
variable "aws_access_me" {}
variable "aws_secret_me" {}

provider "aws" {
  access_key = var.aws_access_me
  secret_key = var.aws_secret_me
  region     = "us-east-1" # Set your desired AWS region
}

##AWS S3 Bucket creation###
resource "aws_s3_bucket" "site_origin" {
    bucket = "resume-cf"
    tags = {
        environment = "PRD"
    }
}

##AWS Object upload##
resource "aws_s3_object" "text_file" {
    depends_on = [ 
        aws_s3_bucket.site_origin
        ]
        bucket = aws_s3_bucket.site_origin.bucket
        key = "Resume.html"
        source = "<html - path>"                                      ###<---- "Change path detail acording to directory structure"
        server_side_encryption = "AES256"
        content_type = "text/html"
}

##Policy creation## - Blocking public access to S3 bucket
resource "aws_s3_bucket_public_access_block" "site_origin" {
  bucket = aws_s3_bucket.site_origin.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

## Adding bucket server side encryption##
resource "aws_s3_bucket_server_side_encryption_configuration" "site_origin" {
    bucket = aws_s3_bucket.site_origin.bucket
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm     = "AES256"
        }
    }
}

##Enabling bucket versioning##
resource "aws_s3_bucket_versioning" "site_origin" {
  bucket = aws_s3_bucket.site_origin.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

####------Cloudfront_Part--------####
#1# - Origin Access
resource "aws_cloudfront_origin_access_control" "site_access" {
  name                              = "resume-cf"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

#2# Distrubution creation
resource "aws_cloudfront_distribution" "site_origin" {

    depends_on = [ 
        aws_s3_bucket.site_origin,
        aws_cloudfront_origin_access_control.site_access
        ]

        enabled = true
        default_root_object = "Resume.html"
        
    default_cache_behavior {
    allowed_methods  = ["GET", "HEAD",]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.site_origin.id
    viewer_protocol_policy = "https-only"

forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
}
    }
    origin {
        domain_name = aws_s3_bucket.site_origin.bucket_domain_name
        origin_id = aws_s3_bucket.site_origin.id
        origin_access_control_id = aws_cloudfront_origin_access_control.site_access.id
    }
    restrictions {
      geo_restriction {
        restriction_type = "whitelist"
        locations = ["US","IN"]
      }
    }
    viewer_certificate {
      cloudfront_default_certificate = true

    }
  }


####------POLICY_PART--------####
#S3 bucket policy
resource "aws_s3_bucket_policy" "site_origin" {
  depends_on = [ 
    data.aws_iam_policy_document.site_origin
   ]

   bucket = aws_s3_bucket.site_origin.id
   policy = data.aws_iam_policy_document.site_origin.json
   
}

data "aws_iam_policy_document" "site_origin" {
    depends_on = [ 
        aws_cloudfront_distribution.site_origin,
        aws_s3_bucket.site_origin
     ]
    statement {
        sid = "AllowCloudFrontServicePrincipal"
        effect = "Allow"
        actions = [
            "s3:GetObject"
        ]
    principals {
        identifiers = ["cloudfront.amazonaws.com"]
        type = "Service"
}
    resources = [
        join("", [aws_s3_bucket.site_origin.arn, "/*"])
]
    condition {
        test = "StringEquals"
        variable = "AWS:SourceArn"
        values = [aws_cloudfront_distribution.site_origin.arn]

    }

     }
    version = "2008-10-17"
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.site_origin.domain_name
}
