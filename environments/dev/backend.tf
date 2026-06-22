# TODO: Uncomment and update these placeholders AFTER you have successfully deployed the bootstrap layer!
# The bootstrap outputs will provide the exact `bucket` and `dynamodb_table` names.

# terraform {
#   backend "s3" {
#     bucket         = "REPLACE_WITH_BOOTSTRAP_STATE_BUCKET_NAME"
#     key            = "dev/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "REPLACE_WITH_BOOTSTRAP_DYNAMODB_TABLE_NAME"
#     encrypt        = true
#   }
# }
