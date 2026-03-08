# =============================================================================
# Glue Connection (JDBC to RDS)
# =============================================================================

resource "aws_glue_connection" "rds" {
  name            = "${var.project_name}-rds-connection"
  connection_type = "JDBC"

  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:mysql://${aws_db_instance.main.endpoint}/${var.rds_database_name}"
    USERNAME            = var.rds_username
    PASSWORD            = var.rds_password
  }

  physical_connection_requirements {
    availability_zone      = var.availability_zones[0]
    security_group_id_list = [aws_security_group.glue.id]
    subnet_id              = aws_subnet.private[0].id
  }
}
