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


function create:airflow_dags {
    kubectl apply -f manifests/role.yml
    kubectl apply -f manifests/role_binding.yml
    envsubst < manifests/dags_configmap.yml | kubectl apply -f -
    kubectl apply -f manifests/airflow.yml
}

function delete:airflow_dags {
    airflow_files=(
    "role.yml"
    "role_binding.yml"
    "dags_configmap.yml"
    "airflow.yml"
    )

    for file in "${airflow_files[@]}"; do
        kubectl delete -f "manifests/$file"
    done
}

function create:spark_application {
    envsubst < manifests/spark.yml | kubectl apply -f -
}

function delete:spark_application {
    kubectl delete -f manifests/spark.yml
}

function help {
    echo "$0 <task> [args]"
    echo "Tasks:"
    compgen -A function | cat -n
}

function build_docker_image {
    docker build -t ciaa/spark_app:"${@:-v1.0.0}" \
        --push . > build.log 2>&1
}

TIMEFORMAT="Task completed in %3lR"
time ${@:-help}
