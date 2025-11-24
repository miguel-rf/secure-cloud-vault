provider "aws" {
  region = "eu-north-1" # Change if you used a different region in 'aws configure'
}

resource "aws_s3_bucket" "backup_vault" {
  bucket_prefix = "secure-vault-" 
  force_destroy = true 
}

resource "aws_s3_bucket_versioning" "vault_versioning" {
  bucket = aws_s3_bucket.backup_vault.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "vault_encryption" {
  bucket = aws_s3_bucket.backup_vault.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "vault_block" {
  bucket = aws_s3_bucket.backup_vault.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_user" "backup_bot" {
  name = "backup_bot_user"
}

resource "aws_iam_access_key" "backup_bot_key" {
  user = aws_iam_user.backup_bot.name
}

resource "aws_iam_user_policy" "backup_bot_policy" {
  name = "backup_bot_access"
  user = aws_iam_user.backup_bot.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:PutObject", "s3:ListBucket", "s3:GetObject"]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.backup_vault.arn,
          "${aws_s3_bucket.backup_vault.arn}/*"
        ]
      }
    ]
  })
}

output "bucket_name" {
  value = aws_s3_bucket.backup_vault.id
}

output "access_key" {
  value     = aws_iam_access_key.backup_bot_key.id
  sensitive = true
}

output "secret_key" {
  value     = aws_iam_access_key.backup_bot_key.secret
  sensitive = true
}
