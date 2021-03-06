## docker-vaultwarden

[![docker hub](https://img.shields.io/badge/docker_hub-link-blue?style=for-the-badge&logo=docker)](https://hub.docker.com/r/vcxpz/vaultwarden) ![docker image size](https://img.shields.io/docker/image-size/vcxpz/vaultwarden?style=for-the-badge&logo=docker) [![auto build](https://img.shields.io/badge/docker_builds-automated-blue?style=for-the-badge&logo=docker?color=d1aa67)](https://github.com/hydazz/docker-vaultwarden/actions?query=workflow%3A"Auto+Builder+CI")

**This is an unofficial image that has been modified for my own needs. If my needs match your needs, feel free to use this image at your own risk.**

Fork of [dani-garcia/vaultwarden](https://github.com/dani-garcia/vaultwarden/)

[vaultwarden](https://vaultwarden.com/) is an open source password management solutions for individuals, teams, and business organizations.

## Usage

```bash
docker run -d \
  --name=vaultwarden \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Australia/Melbourne \
  -p 80:80 \
  -p 3012:3012 \
  -v <path to appdata>:/config \
  --restart unless-stopped \
  vcxpz/vaultwarden
```

[![template](https://img.shields.io/badge/unraid_template-ff8c2f?style=for-the-badge&logo=docker?color=d1aa67)](https://github.com/hydazz/docker-templates/blob/main/hydaz/vaultwarden.xml)

## New Environment Variables

| Name    | Description                                                                                              | Default Value |
| ------- | -------------------------------------------------------------------------------------------------------- | ------------- |
| `DEBUG` | set `true` to display errors in the Docker logs. When set to `false` the Docker log is completely muted. | `false`       |

**See other variables on the official [wiki](https://github.com/dani-garcia/vaultwarden/wiki/)**

## Upgrading vaultwarden

To upgrade, all you have to do is pull the latest Docker image. We automatically check for vaultwarden [(vaultwarden)](https://github.com/dani-garcia/vaultwarden/) updates daily. When a new version is released, we build and publish an image both as a version tag and on `:latest`.

## Fixing Appdata Permissions

If you ever accidentally screw up the permissions on the appdata folder, run `fix-perms` within the container. This will restore most of the files/folders with the correct permissions.
