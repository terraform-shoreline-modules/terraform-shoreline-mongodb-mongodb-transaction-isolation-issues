resource "shoreline_notebook" "mongodb_transaction_isolation_issues" {
  name       = "mongodb_transaction_isolation_issues"
  data       = file("${path.module}/data/mongodb_transaction_isolation_issues.json")
  depends_on = [shoreline_action.invoke_update_mongo_isolation_level]
}

resource "shoreline_file" "update_mongo_isolation_level" {
  name             = "update_mongo_isolation_level"
  input_file       = "${path.module}/data/update_mongo_isolation_level.sh"
  md5              = filemd5("${path.module}/data/update_mongo_isolation_level.sh")
  description      = "Check the MongoDB isolation level configuration and ensure it is set to the appropriate level based on the application's requirements."
  destination_path = "/tmp/update_mongo_isolation_level.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_mongo_isolation_level" {
  name        = "invoke_update_mongo_isolation_level"
  description = "Check the MongoDB isolation level configuration and ensure it is set to the appropriate level based on the application's requirements."
  command     = "`chmod +x /tmp/update_mongo_isolation_level.sh && /tmp/update_mongo_isolation_level.sh`"
  params      = ["DESIRED_ISOLATION_LEVEL"]
  file_deps   = ["update_mongo_isolation_level"]
  enabled     = true
  depends_on  = [shoreline_file.update_mongo_isolation_level]
}

