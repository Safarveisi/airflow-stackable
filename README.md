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
# S3_BUCKET, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, S3_HOST, and S3_BUCKET_REGION.
./run.sh create:airflow_dags
```

> [!TIP]
> You can use Terraform to easily provision a Kubernetes cluster on IONOS Cloud. If you choose this approach, refer to the `terraform` directory for the necessary configuration files and setup instructions.

> [!NOTE]
> The `helpers` directory contains a Python module designed to retrieve the kubeconfig for Kubernetes clusters hosted on the IONOS Cloud. If you're using a different cloud provider, you can safely ignore this folder.

### Continuous integration/continuous deployment (CI/CD)
I used GitHub Actions for CI/CD. Please see `.github/workflows/check_build_and_deploy.yml`.
