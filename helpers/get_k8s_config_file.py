# This module is useful only if you are using ionos-cloud provider for terraform

import argparse
import os

import requests
import yaml

# Default directory to put the cluster's config file
KUBECONFIG_DIR = os.path.join(os.path.expanduser("~"), ".kube")


def get_ionos_k8s_kubeconfig(k8s_cluster_id: str) -> None:
    """Calls IONOS cloud API to get the k8s cluster's config
    file and saves it in $HOME/.kube/.

    Parameters
    ==========
    k8s_cluster_id: str
        K8s cluster id. The id is generated after creating the
        cluster using e.g. Terraform.
    """
    if not os.path.isdir(KUBECONFIG_DIR):
        os.makedirs(KUBECONFIG_DIR, exist_ok=True)
    try:
        ionos_token = os.environ["TF_VAR_ionos_token"]  # noqa: SIM112
    except KeyError:
        raise

    response = requests.get(
        f"https://api.ionos.com/cloudapi/v6/k8s/{k8s_cluster_id}/kubeconfig",
        headers={
            "Authorization": f"Bearer {ionos_token}",
            "content-type": "application/yaml",
        },
    )
    response.raise_for_status()

    try:
        yaml_content = yaml.safe_load(response.content)
    except yaml.YAMLError as e:
        print(f"Error processing YAML content: {e}")
        exit(1)

    file_path = os.path.join(KUBECONFIG_DIR, "config")
    with open(file_path, "w") as yaml_file:
        yaml.safe_dump(yaml_content, yaml_file, default_flow_style=False)

    print(f"Kubeconfig has been written to {file_path}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--id", help="Managed Kubernetes cluster id", required=True)
    args = parser.parse_args()

    get_ionos_k8s_kubeconfig(k8s_cluster_id=args.id)
