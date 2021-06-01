resource "aws_s3_bucket" "aws_s3_bucket" {
  for_each = {
    "dev"  = "kasunbucketdev"
    "qa"   = "kasunbucketqa"
    "prod" = "kasunbucketprod"
  }

  bucket = "${each.key}-${each.value}"
  acl    = "private"

  tags = {
    "env" = each.key
  }
}