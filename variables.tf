# =============================================================================
# General
# =============================================================================

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "glue-etl"
}

# =============================================================================
# S3 Parquet Paths
# =============================================================================

variable "s3_path_rds1" {
  description = "S3 path for RDS1 Parquet data (e.g., s3://bucket/rds1-export/)"
  type        = string
}

variable "s3_path_rds2" {
  description = "S3 path for RDS2 Parquet data (e.g., s3://bucket/rds2-export/)"
  type        = string
}

variable "s3_path_rds3" {
  description = "S3 path for RDS3 Parquet data (e.g., s3://bucket/rds3-export/)"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name for Glue scripts"
  type        = string
}

# =============================================================================
# RDS Configuration
# =============================================================================

variable "rds_username" {
  description = "RDS master username"
  type        = string
  default     = "admin"
}

variable "rds_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 20
}

variable "rds_database_name" {
  description = "RDS database name"
  type        = string
  default     = "integrated_db"
}

# =============================================================================
# Schedule Configuration
# =============================================================================

variable "crawler_schedule" {
  description = "Cron schedule for Crawler (UTC). Default: AM 1:00 JST = 16:00 UTC"
  type        = string
  default     = "cron(0 16 * * ? *)"
}

variable "job_schedule" {
  description = "Cron schedule for ETL Job (UTC). Default: AM 2:00 JST = 17:00 UTC"
  type        = string
  default     = "cron(0 17 * * ? *)"
}

# =============================================================================
# Glue Job Configuration
# =============================================================================

variable "glue_job_worker_type" {
  description = "Glue job worker type"
  type        = string
  default     = "G.1X"
}

variable "glue_job_number_of_workers" {
  description = "Number of Glue job workers"
  type        = number
  default     = 2
}

variable "glue_version" {
  description = "Glue version"
  type        = string
  default     = "4.0"
}

# =============================================================================
# Network Configuration
# =============================================================================

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c"]
}
