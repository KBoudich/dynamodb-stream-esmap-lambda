provider "aws" {
  region = "eu-west-1"
}

module "insert_lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 4.0"

  function_name = "${random_pet.this.id}-lambda"
  description   = "lambda function event source mapped to ${module.dynamodb_table.dynamodb_table_id} INSERT events"
  handler       = "insert.lambda_handler"
  runtime       = "python3.8"
  publish       = true

  source_path = "./lambda"

  allowed_triggers = {
    dynamodb = {
      principal  = "dynamodb.amazonaws.com"
      source_arn = module.dynamodb_table.dynamodb_table_stream_arn
    }
  }

  event_source_mapping = {
    dynamodb = {
      event_source_arn  = module.dynamodb_table.dynamodb_table_stream_arn
      starting_position = "LATEST"
      filter_criteria = {
        pattern = jsonencode({
          eventName : ["INSERT"]
        })
      }
    }
  }

  attach_policies    = true
  number_of_policies = 1

  policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole",
  ]
}


module "update_lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 4.0"

  function_name = "${random_pet.this.id}-lambda-update"
  description   = "lambda function event source mapped to ${module.dynamodb_table.dynamodb_table_id} UPDATE (MODIFY) events"
  handler       = "update.lambda_handler"
  runtime       = "python3.8"
  publish       = true

  source_path = "./lambda"

  allowed_triggers = {
    dynamodb = {
      principal  = "dynamodb.amazonaws.com"
      source_arn = module.dynamodb_table.dynamodb_table_stream_arn
    }
  }

  event_source_mapping = {
    dynamodb = {
      event_source_arn  = module.dynamodb_table.dynamodb_table_stream_arn
      starting_position = "LATEST"
      filter_criteria = {
        pattern = jsonencode({
          eventName : ["MODIFY"]
        })
      }
    }
  }

  attach_policies    = true
  number_of_policies = 1

  policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole",
  ]
}

module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~> 1.0"

  name             = "${random_pet.this.id}-table-with-stream"
  hash_key         = "id"
  table_class      = "STANDARD"
  stream_view_type = "NEW_AND_OLD_IMAGES"
  stream_enabled   = true

  attributes = [
    {
      name = "id"
      type = "N"
    }
  ]
}

resource "random_pet" "this" {
  length = 2
}
