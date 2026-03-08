# =============================================================================
# Glue Catalog Database
# =============================================================================

resource "aws_glue_catalog_database" "main" {
  name        = "${replace(var.project_name, "-", "_")}_catalog"
  description = "Catalog database for integrated RDS data"

  create_table_default_permission {
    permissions = ["ALL"]

    principal {
      data_lake_principal_identifier = "IAM_ALLOWED_PRINCIPALS"
    }
  }
}
