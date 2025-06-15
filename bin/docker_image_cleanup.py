
from docker import DockerClient, from_env
from docker.errors import APIError
from docker.models.images import Image


def filter_image(image: Image) -> list[str]:
    tags = image.tags
    to_remove: list[str] = list()
    if len(tags) == 0:
        to_remove.append(image.id)
    else:
        for tag in tags:
            if tag.startswith("docker.maple.maceroc.com"):
                to_remove.append(tag)
    return to_remove

def list_images(client: DockerClient) -> list[str]:
    images = client.images.list()
    to_remove: list[str] = list()
    for img in images:
        tags = filter_image(img)
        to_remove.extend(tags)
    return to_remove

def remove_tags(client: DockerClient, tags: list[str]):
    for tag in tags:
        try:
            client.images.remove(tag)
            print(f"Removed {tag}")
        except APIError as apie:
            if apie.status_code == 409:
                print(f"Not removing {tag}, image in use")

def main():
    client = from_env()
    tags = list_images(client)
    remove_tags(client, tags)


if __name__ == '__main__':
    main()