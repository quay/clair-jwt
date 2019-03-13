# clair-jwt

This repository houses a Dockerfile for building the official clair-jwt container image.

This image executes [clair] behind [jwtproxy], which is how secure [Quay Enterprise] installations are configured.
[cfssl] is used to generate certificates internal certificates used with jwtproxy.

For more information, see [the documentation for setting up Clair with Quay](https://coreos.com/quay-enterprise/docs/latest/clair.html).

[clair]: https://github.com/coreos/clair
[jwtproxy]: https://github.com/coreos/jwtproxy
[cfssl]: https://github.com/cloudflare/cfssl
[Quay Enterprise]: https://quay.io/plans/?tab=enterprise

## Building the image

By providing the build-arg `GIT_TAG`, you can specify what branch/tag of Clair you wish to build.

alpine: 
```sh
make alpine GIT_TAG=v2.0.9
```
It produces `quay.io/coreos/clair-jwt:v2.0.9-alpine`

centOS: 
```sh
make centos7-build-env centos7 GIT_TAG=v2.0.9
```
It produces `quay.io/coreos/clair-jwt:v2.0.9-centos7`

The command `make centos7-build-env` produces a build environment, tagged as `quay.io/coreos/clair-jwt:<version>-centos7-build-env` for the centos and rhel based images.
