# =============================================================================
# EventBridge Rule for Glue ETL Job
# =============================================================================

resource "aws_cloudwatch_event_rule" "glue_job" {
  name                = "${var.project_name}-etl-job-schedule"
  description         = "Trigger Glue ETL Job daily at AM 2:00 JST"
  schedule_expression = var.job_schedule

  tags = {
    Name = "${var.project_name}-etl-job-schedule"
  }
}

resource "aws_cloudwatch_event_target" "glue_job" {
  rule      = aws_cloudwatch_event_rule.glue_job.name
  target_id = "GlueETLJob"
  arn       = "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:job/${aws_glue_job.etl.name}"
  role_arn  = aws_iam_role.eventbridge_glue.arn
}
