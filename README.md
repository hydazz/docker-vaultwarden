## docker-bitwarden

[![docker hub](https://img.shields.io/badge/docker_hub-link-blue?style=for-the-badge&logo=docker)](https://hub.docker.com/r/vcxpz/bitwarden) ![docker image size](https://img.shields.io/docker/image-size/vcxpz/bitwarden?style=for-the-badge&logo=docker) [![auto build](https://img.shields.io/badge/docker_builds-automated-blue?style=for-the-badge&logo=docker?color=d1aa67)](https://github.com/hydazz/docker-bitwarden/actions?query=workflow%3A"Auto+Builder+CI") [![codacy branch grade](https://img.shields.io/codacy/grade/5189a12d0d9d45c7a7c61012208fe5ee/main?style=for-the-badge&logo=codacy)](https://app.codacy.com/gh/hydazz/docker-bitwarden)

**This is an unofficial image that has been modified for my own needs. If my needs match your needs, feel free to use this image at your own risk.**

Fork of [dani-garcia/bitwarden_rs](https://github.com/dani-garcia/bitwarden_rs/)

[Bitwarden](https://bitwarden.com/) is an open source password management solutions for individuals, teams, and business organizations.

## Usage

```bash
docker run -d \
  --name=bitwarden \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Australia/Melbourne \
  -p 80:80 \
  -p 3012:3012 \
  -v <path to appdata>:/config \
  --restart unless-stopped \
  vcxpz/bitwarden
```

[![template](https://img.shields.io/badge/unraid_template-ff8c2f?style=for-the-badge&logo=docker?color=d1aa67)](https://github.com/hydazz/docker-templates/blob/main/hydaz/bitwarden.xml)

## New Environment Variables

| Name    | Description                                                                                              | Default Value |
| ------- | -------------------------------------------------------------------------------------------------------- | ------------- |
| `DEBUG` | set `true` to display errors in the Docker logs. When set to `false` the Docker log is completely muted. | `false`       |

**See other variables on the official [wiki](https://github.com/dani-garcia/bitwarden_rs/wiki/)**

## Upgrading Bitwarden

To upgrade, all you have to do is pull the latest Docker image. We automatically check for Bitwarden [(bitwarden_rs)](https://github.com/dani-garcia/bitwarden_rs/) updates daily. When a new version is released, we build and publish an image both as a version tag and on `:latest`.

## Fixing Appdata Permissions

If you ever accidentally screw up the permissions on the appdata folder, run `fix-perms` within the container. This will restore most of the files/folders with the correct permissions.
