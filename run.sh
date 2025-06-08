#!/bin/bash

function remove:operator {
    stackablectl operator uninstall \
        "${@:-commons}"
}

function install:commons {
    stackablectl operator install \
        commons=25.3.0 \
        secret=25.3.0 \
        listener=25.3.0
}

function install:spark_k8s {
    stackablectl operator install \
        spark-k8s=25.3.0
}


function install:airflow {
    stackablectl operator install \
        airflow=25.3.0
}

function install:airflow_dependencies {

    helm install airflow-postgresql oci://registry-1.docker.io/bitnamicharts/postgresql \
        --version 16.5.0 \
        --set auth.database=airflow \
        --set auth.username=airflow \
        --set auth.password=airflow \
        --wait

    helm install airflow-redis oci://registry-1.docker.io/bitnamicharts/redis \
        --version 20.11.3 \
        --set replica.replicaCount=1 \
        --set auth.password=redis \
        --wait
}

function remove:airflow_dependencies {
    helm uninstall airflow-postgresql
    helm uninstall airflow-redis
}


function create_airflow_dags {
    envsubst < airflow.yml | kubectl apply -f -
}

function delete_airflow_dags {
    kubectl delete -f airflow.yml
}

function create_spark_application {
    envsubst < spark.yml | kubectl apply -f -
}

function delete_spark_application {
    kubectl delete -f spark.yml
}

function help {
    echo "$0 <task> [args]"
    echo "Tasks:"
    compgen -A function | cat -n
}

TIMEFORMAT="Task completed in %3lR"
time ${@:-help}
