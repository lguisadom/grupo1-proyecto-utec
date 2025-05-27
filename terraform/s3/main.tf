resource "aws_s3_bucket" "glue_scripts" {
  bucket = "s3-${var.group}-${var.env}-${var.s3_name}-${var.prefix}"
}
