import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrame

# =============================================================================
# Get job parameters
# =============================================================================

args = getResolvedOptions(sys.argv, [
    'JOB_NAME',
    'DATABASE_NAME',
    'TABLE_NAME_RDS1',
    'TABLE_NAME_RDS2',
    'TABLE_NAME_RDS3',
    'CONNECTION_NAME',
    'TARGET_TABLE'
])

# =============================================================================
# Initialize Glue context
# =============================================================================

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# =============================================================================
# Read data from Glue Data Catalog
# =============================================================================

print(f"Reading from catalog: {args['DATABASE_NAME']}")

# Read RDS1 data
df1 = glueContext.create_dynamic_frame.from_catalog(
    database=args['DATABASE_NAME'],
    table_name=args['TABLE_NAME_RDS1'],
    transformation_ctx="df1"
)
print(f"RDS1 records: {df1.count()}")

# Read RDS2 data
df2 = glueContext.create_dynamic_frame.from_catalog(
    database=args['DATABASE_NAME'],
    table_name=args['TABLE_NAME_RDS2'],
    transformation_ctx="df2"
)
print(f"RDS2 records: {df2.count()}")

# Read RDS3 data
df3 = glueContext.create_dynamic_frame.from_catalog(
    database=args['DATABASE_NAME'],
    table_name=args['TABLE_NAME_RDS3'],
    transformation_ctx="df3"
)
print(f"RDS3 records: {df3.count()}")

# =============================================================================
# Transform and merge data
# =============================================================================

# Convert to Spark DataFrames for complex transformations
spark_df1 = df1.toDF()
spark_df2 = df2.toDF()
spark_df3 = df3.toDF()

# Option 1: Union (stack all records)
# Use this if all 3 sources have the same schema
merged_df = spark_df1.unionByName(spark_df2, allowMissingColumns=True) \
                     .unionByName(spark_df3, allowMissingColumns=True)

# Option 2: Join (if you need to join on a key)
# Uncomment and modify as needed:
# merged_df = spark_df1 \
#     .join(spark_df2, "user_id", "full_outer") \
#     .join(spark_df3, "user_id", "full_outer")

# Option 3: Aggregation example
# Uncomment and modify as needed:
# from pyspark.sql.functions import sum, count
# merged_df = spark_df1 \
#     .groupBy("region") \
#     .agg(sum("amount").alias("total_amount"), count("*").alias("record_count"))

# Remove duplicates if needed
merged_df = merged_df.dropDuplicates()

print(f"Merged records: {merged_df.count()}")

# Convert back to DynamicFrame
merged_dynamic_frame = DynamicFrame.fromDF(merged_df, glueContext, "merged")

# =============================================================================
# Write to RDS
# =============================================================================

print(f"Writing to RDS table: {args['TARGET_TABLE']}")

glueContext.write_dynamic_frame.from_jdbc_conf(
    frame=merged_dynamic_frame,
    catalog_connection=args['CONNECTION_NAME'],
    connection_options={
        "dbtable": args['TARGET_TABLE'],
        "database": "integrated_db"
    },
    transformation_ctx="write_to_rds"
)

print("ETL job completed successfully")

# =============================================================================
# Commit job
# =============================================================================

job.commit()
