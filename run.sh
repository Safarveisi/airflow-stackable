#!/bin/bash

HOME_DIR=$(cd ~ && pwd)
STARTING_PATH=$(git rev-parse --show-toplevel)
IDENTIFIER_COMMENT="# LATEST_IMAGE_TAG"

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
    envsubst < manifests/pyspark.yml | kubectl apply -f -
}

function delete:spark_application {
    kubectl delete -f manifests/pyspark.yml
}

function help {
    echo "$0 <task> [args]"
    echo "Tasks:"
    compgen -A function | cat -n
}

function build_docker_image {
    docker build -t ciaa/spark_app:"${@:-v1.0.0}" \
        --check --push . > build.log 2>&1
}

function create_docker_k8s_secret {
    # If you already ran docker login
    kubectl create secret generic docker \
    --from-file=.dockerconfigjson="$HOME"/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson
}

function get_project_version {
    echo "v$(cat pyproject.toml | grep 'version =' | sed -E 's/version = //' | tr -d '\"= ')"
}

function update_docker_image_tag {
    VERSION_TAG=$(get_project_version)
    # Update docker image tags in the manifest files for Spark application and airflow dags
    find "$STARTING_PATH" -type f \( -name "*.yml" \) -exec grep -l "$IDENTIFIER_COMMENT" {} \; | while read -r file; do
        echo "Updating: $file"
        sed -i "s|\(\s*.*:\s*\).* \($IDENTIFIER_COMMENT\)|\1"${@:-$VERSION_TAG}" \2|" "$file";
    done
}

function get_latest_kubectl_release {
    curl --silent "https://api.github.com/repos/kubernetes/kubernetes/releases" \
    | jq '.[] | select(.prerelease==false) | .tag_name' | sort -V -r | head -n 1 | tr -d '"'
}

TIMEFORMAT="Task completed in %3lR"
time ${@:-help}
