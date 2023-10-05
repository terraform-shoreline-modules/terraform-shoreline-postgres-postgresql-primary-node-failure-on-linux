resource "shoreline_notebook" "primary_postgresql_node_failure_on_linux" {
  name       = "primary_postgresql_node_failure_on_linux"
  data       = file("${path.module}/data/primary_postgresql_node_failure_on_linux.json")
  depends_on = [shoreline_action.invoke_df_h_top,shoreline_action.invoke_restart_postgres_service,shoreline_action.invoke_postgresql_failover]
}

resource "shoreline_file" "df_h_top" {
  name             = "df_h_top"
  input_file       = "${path.module}/data/df_h_top.sh"
  md5              = filemd5("${path.module}/data/df_h_top.sh")
  description      = "Check disk space and resource utilization"
  destination_path = "/agent/scripts/df_h_top.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "restart_postgres_service" {
  name             = "restart_postgres_service"
  input_file       = "${path.module}/data/restart_postgres_service.sh"
  md5              = filemd5("${path.module}/data/restart_postgres_service.sh")
  description      = "Restart the failed PostgreSQL node service to bring it back online."
  destination_path = "/agent/scripts/restart_postgres_service.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "postgresql_failover" {
  name             = "postgresql_failover"
  input_file       = "${path.module}/data/postgresql_failover.sh"
  md5              = filemd5("${path.module}/data/postgresql_failover.sh")
  description      = "If restarting the service doesn't work, try to failover to a standby node in the PostgreSQL cluster."
  destination_path = "/agent/scripts/postgresql_failover.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_df_h_top" {
  name        = "invoke_df_h_top"
  description = "Check disk space and resource utilization"
  command     = "`chmod +x /agent/scripts/df_h_top.sh && /agent/scripts/df_h_top.sh`"
  params      = []
  file_deps   = ["df_h_top"]
  enabled     = true
  depends_on  = [shoreline_file.df_h_top]
}

resource "shoreline_action" "invoke_restart_postgres_service" {
  name        = "invoke_restart_postgres_service"
  description = "Restart the failed PostgreSQL node service to bring it back online."
  command     = "`chmod +x /agent/scripts/restart_postgres_service.sh && /agent/scripts/restart_postgres_service.sh`"
  params      = []
  file_deps   = ["restart_postgres_service"]
  enabled     = true
  depends_on  = [shoreline_file.restart_postgres_service]
}

resource "shoreline_action" "invoke_postgresql_failover" {
  name        = "invoke_postgresql_failover"
  description = "If restarting the service doesn't work, try to failover to a standby node in the PostgreSQL cluster."
  command     = "`chmod +x /agent/scripts/postgresql_failover.sh && /agent/scripts/postgresql_failover.sh`"
  params      = ["STANDBY_NODE","PRIMARY_NODE"]
  file_deps   = ["postgresql_failover"]
  enabled     = true
  depends_on  = [shoreline_file.postgresql_failover]
}

