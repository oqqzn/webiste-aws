locals {
  common_tags = {
    company      = var.company
    project      = "${var.company}-${var.project}"
  }

  s3_bucket_name = "website${random_integer.s3.result}"
  # Finds all files in the website directory
  website_files = [for file in fileset("website", "**/*") : file]
}

resource "random_integer" "s3" {
  min = 10000
  max = 99999
}
