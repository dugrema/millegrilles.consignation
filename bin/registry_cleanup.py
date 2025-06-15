import requests

from typing import Optional, Callable

def load_repository_tags(server_url: str, repo_name: str) -> list[str]:
    response = requests.get(f"{server_url}/v2/{repo_name}/tags/list")
    response.raise_for_status()
    content = response.json()
    return content['tags']

def delete_tags(server_url: str, repo_name: str, tags: list[str]):

    headers = {'Accept': 'application/vnd.docker.distribution.manifest.v2+json'}

    for tag in tags:
        # Retrieve blob ID
        response = requests.get(f"{server_url}/v2/{repo_name}/manifests/{tag}", headers=headers)
        if response.status_code == 404:
            print(f"Unable to remove {repo_name}/{tag}")
            continue
        response.raise_for_status()
        content = response.json()
        for (key, value) in response.headers.items():
            pass
        digest_header = response.headers['Docker-Content-Digest']
        response = requests.delete(f"{server_url}/v2/{repo_name}/manifests/{digest_header}")
        if response.status_code == 404:
            print(f"NOT FOUND: {repo_name}/{tag}")
        else:
            response.raise_for_status()
            print(f"DELETED {repo_name}/{tag}" )


CONST_REGISTRY_URL = "https://registry.millegrilles.com:5000"
CONST_REPO_NAME = "millegrilles_media_python"

def main():
    tags = load_repository_tags(CONST_REGISTRY_URL, CONST_REPO_NAME)
    tags = [t for t in tags if filter_by_nomultiarch(t) and filter_by_2023(t)]
    delete_tags(CONST_REGISTRY_URL, CONST_REPO_NAME, tags)

def filter_by_nomultiarch(value: str) -> bool:
    return value.startswith("x86_64_") or value.startswith("aarch64_")

def filter_by_2023(value: str) -> bool:
    return "2023" in value

if __name__ == '__main__':
    main()
    print("Finish the cleanup by running this from the registry container: \n  registry garbage-collect -m /etc/docker/registry/config.yml")
