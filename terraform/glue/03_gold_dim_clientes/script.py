import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from pyspark.sql.functions import col, current_date, to_date
from pyspark.sql.types import DecimalType, IntegerType
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql import SQLContext
from awsglue.dynamicframe import DynamicFrame

## @params: [JOB_NAME]
args = getResolvedOptions(sys.argv, ['JOB_NAME', 'tableName'])
tableName = args['tableName']
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

#  Iceberg Config
spark.conf.set("spark.sql.catalog.glue_catalog", "org.apache.iceberg.spark.SparkCatalog")
spark.conf.set("spark.sql.catalog.glue_catalog.warehouse", "s3://dlk-g1/gold/")  # or your correct warehouse
spark.conf.set("spark.sql.catalog.glue_catalog.catalog-impl", "org.apache.iceberg.aws.glue.GlueCatalog")
spark.conf.set("spark.sql.catalog.glue_catalog.io-impl", "org.apache.iceberg.aws.s3.S3FileIO")
spark.conf.set("spark.sql.defaultCatalog", "glue_catalog")
# Configuración adicional al inicio del script
spark.conf.set("spark.sql.catalog.dynamodb", "org.apache.spark.sql.dynamodb.DynamoDBCatalog")
spark.conf.set("spark.dynamodb.region", "us-east-1")

# 1. Read source customers table (silver or bronze customers)
source_df = spark.read.format("iceberg").load("glue_catalog.`dbg1`.clientes")

# 2. Escribir a DynamoDB usando Glue (NO SPARK directamente)
source_dynamic_df = DynamicFrame.fromDF(source_df, glueContext, "source_dynamic_df")

glueContext.write_dynamic_frame.from_options(
    frame=source_dynamic_df,
    connection_type="dynamodb",
    connection_options={
        "dynamodb.output.tableName": tableName,
        "dynamodb.throughput.write.percent": "1.0"
    }
)

# 3. Escribir a tabla Iceberg en capa Gold
source_df.writeTo("glue_catalog.`utec_gold_dbg1`.dim_cliente").append()

job.commit()
