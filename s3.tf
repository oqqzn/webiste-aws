resource "aws_s3_bucket" "web_bucket" {
  bucket        = local.s3_bucket_name
  force_destroy = true

}


resource "aws_s3_bucket_policy" "web_bucket" {
  bucket = aws_s3_bucket.web_bucket.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_elb_service_account.root.arn}"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}"
    }
  ]
}
    POLICY
}



resource "aws_s3_object" "website" {
  for_each = toset(local.website_files)

  bucket = aws_s3_bucket.web_bucket.bucket
  # Each file's S3 object key will be prefixed with 'website/' to create a folder-like structure
  key    = "website/${each.value}"
  source = "website/${each.value}"          # Local file to upload from 'website/' directory
  etag   = filemd5("website/${each.value}") # MD5 checksum for each file
}
