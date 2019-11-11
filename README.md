# clair-jwt

This repository houses a Dockerfile for building the official clair-jwt container image.

This image executes [clair] behind [jwtproxy], which is how secure [Quay Project] installations are configured.

[quay]: https://quay.io/quay/quay
[clair]: https://github.com/coreos/clair
[jwtproxy]: https://github.com/coreos/jwtproxy

## Building the image

```sh
podman build Dockerfile.ubi7 .
```
