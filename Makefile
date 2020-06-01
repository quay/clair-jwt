GIT_TAG ?= v2.1.4
REPO_NAME ?= quay.io/projectquay/clair-jwt
SUBSCRIPTION_KEY ?= ./subscription.pem

centos7-build-env: Dockerfile.centos7-build-env
	echo "Building Clair build environment with tag: '${REPO_NAME}:${GIT_TAG}-centos7-build-env'"
	docker build -f Dockerfile.centos7-build-env -t ${REPO_NAME}:${GIT_TAG}-centos7-build-env . --build-arg GIT_TAG=${GIT_TAG}

centos7: centos7-build-env Dockerfile.centos7
	echo "Building CentOS based image with tag: '${REPO_NAME}:${GIT_TAG}-centos7'"
	docker build -f Dockerfile.centos7 -t ${REPO_NAME}:${GIT_TAG}-centos7 . --build-arg GIT_TAG=${GIT_TAG} --build-arg REPO_NAME=${REPO_NAME}

rhel7: centos7-build-env Dockerfile.rhel7
	echo "Building RHEL based image with tag: '${REPO_NAME}:${GIT_TAG}-rhel7', with path to subscription key '${SUBSCRIPTION_KEY}' (PEM format)"
	# squash is necessary to hide the secrets added during docker build.
	docker build --squash -f Dockerfile.rhel7 -t ${REPO_NAME}:${GIT_TAG}-rhel7 . --build-arg GIT_TAG=${GIT_TAG}  --build-arg REPO_NAME=${REPO_NAME} --build-arg SUBSCRIPTION_KEY=${SUBSCRIPTION_KEY}

ubi7: centos7-build-env Dockerfile.ubi7
	echo "Building RHEL UBI based image with tag: '${REPO_NAME}:${GIT_TAG}-ubi7'"
	docker build -f Dockerfile.ubi7 -t ${REPO_NAME}:${GIT_TAG}-ubi7 . \
      --build-arg GIT_TAG=${GIT_TAG} \
	    --build-arg REPO_NAME=${REPO_NAME}

alpine: Dockerfile.alpine
	echo "Building Alpine based image with tag: '${REPO_NAME}:${GIT_TAG}-alpine'"
	docker build -f Dockerfile.alpine -t ${REPO_NAME}:${GIT_TAG}-alpine . --build-arg GIT_TAG=${GIT_TAG}
