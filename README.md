## Scheduling Spark Applications using Airflow

Leverage Apache Airflow to schedule and monitor a Spark application running on Kubernetes. This setup uses the Airflow Spark Operator to submit jobs and a Spark sensor to track their execution status.

The Spark Operator deploys an instance of the Stackable SparkApplication custom resource (CRD) to the Kubernetes cluster. Meanwhile, the sensor actively monitors the job, waiting for a success or failure signal.

![Airflow and Spark](./airflow.png)
