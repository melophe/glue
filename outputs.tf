# =============================================================================
# Outputs
# =============================================================================

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.main.endpoint
}

output "rds_database_name" {
  description = "RDS database name"
  value       = aws_db_instance.main.db_name
}

output "glue_catalog_database" {
  description = "Glue catalog database name"
  value       = aws_glue_catalog_database.main.name
}

output "glue_crawler_name" {
  description = "Glue crawler name"
  value       = aws_glue_crawler.main.name
}

output "glue_job_name" {
  description = "Glue ETL job name"
  value       = aws_glue_job.etl.name
}

output "glue_connection_name" {
  description = "Glue RDS connection name"
  value       = aws_glue_connection.rds.name
}

output "eventbridge_rule_name" {
  description = "EventBridge rule name for ETL job"
  value       = aws_cloudwatch_event_rule.glue_job.name
}

# =============================================================================
# Schedule Information
# =============================================================================

output "crawler_schedule" {
  description = "Crawler schedule (UTC)"
  value       = var.crawler_schedule
}

output "job_schedule" {
  description = "ETL Job schedule (UTC)"
  value       = var.job_schedule
}
