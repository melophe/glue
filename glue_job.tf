# =============================================================================
# S3 bucket for Glue scripts
# =============================================================================

resource "aws_s3_object" "etl_script" {
  bucket = var.s3_bucket_name
  key    = "glue-scripts/etl_job.py"
  source = "${path.module}/scripts/etl_job.py"
  etag   = filemd5("${path.module}/scripts/etl_job.py")
}

# =============================================================================
# Glue ETL Job
# =============================================================================

resource "aws_glue_job" "etl" {
  name     = "${var.project_name}-etl-job"
  role_arn = aws_iam_role.glue.arn

  glue_version      = var.glue_version
  worker_type       = var.glue_job_worker_type
  number_of_workers = var.glue_job_number_of_workers

  command {
    name            = "glueetl"
    script_location = "s3://${var.s3_bucket_name}/glue-scripts/etl_job.py"
    python_version  = "3"
  }

  default_arguments = {
    "--job-language"                     = "python"
    "--enable-metrics"                   = "true"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-glue-datacatalog"          = "true"
    "--TempDir"                          = "s3://${var.s3_bucket_name}/glue-temp/"

    # Custom arguments
    "--DATABASE_NAME"    = aws_glue_catalog_database.main.name
    "--TABLE_NAME_RDS1"  = "rds1_data"
    "--TABLE_NAME_RDS2"  = "rds2_data"
    "--TABLE_NAME_RDS3"  = "rds3_data"
    "--CONNECTION_NAME"  = aws_glue_connection.rds.name
    "--TARGET_TABLE"     = "integrated_table"
  }

  connections = [aws_glue_connection.rds.name]

  execution_property {
    max_concurrent_runs = 1
  }

  timeout = 60 # minutes

  tags = {
    Name = "${var.project_name}-etl-job"
  }
}
