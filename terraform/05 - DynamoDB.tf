resource "aws_dynamodb_table" "dynamodbtable" {
  name           = "cloudresume-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  attribute {
    name = "Id"
    type = "S"
  }
    hash_key = "Id"
}

resource "aws_dynamodb_table_item" "dynamodbtableitem" {
  table_name = aws_dynamodb_table.dynamodbtable.name
  hash_key   = aws_dynamodb_table.dynamodbtable.hash_key

  item = <<EOF
{
  "Id": {"S": "1"},
  "views": {"N": "1"}
}
EOF

# make it so that item isnt updated after apply changes
lifecycle {
  ignore_changes = [item]
}
}
