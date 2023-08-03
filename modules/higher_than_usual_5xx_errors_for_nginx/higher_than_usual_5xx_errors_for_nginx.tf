resource "shoreline_notebook" "higher_than_usual_5xx_errors_for_nginx" {
  name       = "higher_than_usual_5xx_errors_for_nginx"
  data       = file("${path.module}/data/higher_than_usual_5xx_errors_for_nginx.json")
  depends_on = [shoreline_action.invoke_check_upstream_status,shoreline_action.invoke_increase_nginx_workers]
}

resource "shoreline_file" "check_upstream_status" {
  name             = "check_upstream_status"
  input_file       = "${path.module}/data/check_upstream_status.sh"
  md5              = filemd5("${path.module}/data/check_upstream_status.sh")
  description      = "Check if the upstream server is responding with a HTTP 200 status code"
  destination_path = "/agent/scripts/check_upstream_status.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "increase_nginx_workers" {
  name             = "increase_nginx_workers"
  input_file       = "${path.module}/data/increase_nginx_workers.sh"
  md5              = filemd5("${path.module}/data/increase_nginx_workers.sh")
  description      = "Increase the number of NGINX worker processes to handle the increased traffic and prevent the server from getting overloaded."
  destination_path = "/agent/scripts/increase_nginx_workers.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_check_upstream_status" {
  name        = "invoke_check_upstream_status"
  description = "Check if the upstream server is responding with a HTTP 200 status code"
  command     = "`chmod +x /agent/scripts/check_upstream_status.sh && /agent/scripts/check_upstream_status.sh`"
  params      = ["UPSTREAM_URL"]
  file_deps   = ["check_upstream_status"]
  enabled     = true
  depends_on  = [shoreline_file.check_upstream_status]
}

resource "shoreline_action" "invoke_increase_nginx_workers" {
  name        = "invoke_increase_nginx_workers"
  description = "Increase the number of NGINX worker processes to handle the increased traffic and prevent the server from getting overloaded."
  command     = "`chmod +x /agent/scripts/increase_nginx_workers.sh && /agent/scripts/increase_nginx_workers.sh`"
  params      = ["NUM_WORKERS"]
  file_deps   = ["increase_nginx_workers"]
  enabled     = true
  depends_on  = [shoreline_file.increase_nginx_workers]
}

