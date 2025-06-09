## Scheduling Spark Applications using Airflow

Leverage Apache Airflow to schedule and monitor a Spark application running on Kubernetes. This setup uses the Airflow Spark Operator to submit jobs and a Spark sensor to track their execution status.

The Spark Operator deploys an instance of the Stackable SparkApplication custom resource (CRD) to the Kubernetes cluster. Meanwhile, the sensor actively monitors the job, waiting for a success or failure signal.

![Airflow and Spark](./airflow.png)

### Usage

1️⃣ Install the Airflow K8s operator by running
```bash
./run.sh install:commons
./run.sh install:airflow_dependencies
./run.sh install:airflow
```
2️⃣ Install the the Spark K8s operator by running
```bash
./run.sh install:commons # If you have not installed them yet
./run.sh install:spark_k8s
```
3️⃣ Create Airflow dags
```bash
# Ensure that s3_script.py has already been uploaded to the specified S3 bucket. Refer to line 214 in manifests/dags_configmap.yml for details.
# Before running the command below, make sure the following environment variables are set:
# S3_BUCKET, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, S3_ENDPOINT_URL, and S3_REGION.
./run.sh create:airflow_dags
```
