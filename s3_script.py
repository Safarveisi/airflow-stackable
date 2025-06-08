from pyspark.sql import SparkSession  # type: ignore
from pyspark.sql.functions import col, when  # type: ignore

spark = SparkSession.builder.appName("demo").getOrCreate()

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
    ],
    ["first_name", "age"],
)

df1 = df.withColumn(
    "life_stage",
    when(col("age") < 13, "child")
    .when(col("age").between(13, 19), "teenager")
    .otherwise("adult"),
)

df1.show()
