# =============================================================================
# Glue Crawler
# =============================================================================

resource "aws_glue_crawler" "main" {
  name          = "${var.project_name}-crawler"
  role          = aws_iam_role.glue.arn
  database_name = aws_glue_catalog_database.main.name

  # Crawler schedule (AM 1:00 JST = 16:00 UTC)
  schedule = var.crawler_schedule

  # S3 targets for 3 RDS exports
  s3_target {
    path = var.s3_path_rds1
  }

  s3_target {
    path = var.s3_path_rds2
  }

  s3_target {
    path = var.s3_path_rds3
  }

  # Schema change policy
  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  # Recrawl policy
  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING"
  }

  configuration = jsonencode({
    Version = 1.0
    Grouping = {
      TableGroupingPolicy = "CombineCompatibleSchemas"
    }
    CrawlerOutput = {
      Partitions = {
        AddOrUpdateBehavior = "InheritFromTable"
      }
    }
  })

  tags = {
    Name = "${var.project_name}-crawler"
  }
}
