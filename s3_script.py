from pyspark.sql import SparkSession  # type: ignore
from pyspark.sql.functions import (  # type: ignore
    array,
    avg,
    col,
    concat_ws,
    count,
    current_date,
    desc,
    length,
    lit,
    struct,
    when,
)

# Initialize Spark session
spark = SparkSession.builder.appName("stackable-spark-demo").getOrCreate()
# Enable Arrow-based columnar data transfers
spark.conf.set("spark.sql.execution.arrow.pyspark.enabled", "true")

# Input data
df = spark.createDataFrame(
    [
        ("sue", 32),
        ("li", 3),
        ("bob", 75),
        ("heo", 13),
        ("wo", 19),
        ("jane", 45),
        ("john", 12),
        ("mary", 8),
        ("tom", 20),
        ("alice", 15),
        ("dave", 22),
        ("eve", 30),
        ("charlie", 5),
        ("lucy", 18),
        ("mike", 40),
        ("tom", 40),
        ("eli", 94),
        ("tang", 33),
        ("yolo", 85),
        ("sia", 23),
    ],
    ["first_name", "age"],
)

# Add life stage category
df1 = df.withColumn(
    "life_stage",
    when(col("age") < 13, "child")
    .when(col("age").between(13, 19), "teenager")
    .otherwise("adult"),
)

# Add more derived columns
df2 = (
    df1.withColumn("name_length", length(col("first_name")))
    .withColumn("birth_year_est", lit(2025) - col("age"))
    .withColumn("tags", array(col("life_stage"), col("age").cast("string")))
    .withColumn("metadata", struct("birth_year_est", "name_length"))
    .withColumn("full_id", concat_ws("_", col("first_name"), col("birth_year_est")))
    .withColumn("ingested_on", current_date())
)

# Filter adults only and sort
adults_df = df2.filter(col("life_stage") == "adult").orderBy(desc("age"))

# Aggregation: count and avg age by life stage
summary_df = df2.groupBy("life_stage").agg(
    count("*").alias("count"), avg("age").alias("avg_age")
)

# Show outputs
print("📊 Enriched DataFrame:")
df2.show(truncate=False)

print("🔍 Filtered Adults Sorted by Age:")
adults_df.show()

print("📈 Summary by Life Stage:")
summary_df.show()

# Convert the Spark DataFrame back to a pandas DataFrame using Arrow
result_pdf = summary_df.toPandas()
print(result_pdf)
