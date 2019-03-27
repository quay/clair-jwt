GIT_TAG=master
REPO_NAME=quay.io/coreos/clair-jwt
SUBSCRIPTION_KEY=
centos7-build-env: centos7-build-env.Dockerfile
	echo "Building Clair build environment with tag: '${REPO_NAME}:${GIT_TAG}-centos7-build-env'"
	docker build -f centos7-build-env.Dockerfile -t ${REPO_NAME}:${GIT_TAG}-centos7-build-env . --build-arg GIT_TAG=${GIT_TAG}
centos7: centos7.Dockerfile 
	echo "Building CentOS based image with tag: '${REPO_NAME}:${GIT_TAG}-centos7'"
	docker build -f centos7.Dockerfile -t ${REPO_NAME}:${GIT_TAG}-centos7 . --build-arg GIT_TAG=${GIT_TAG} --build-arg REPO_NAME=${REPO_NAME}
rhel7: rhel7.Dockerfile
	echo "Building RHEL based image with tag: '${REPO_NAME}:${GIT_TAG}-rhel7', with path to subscription key '${SUBSCRIPTION_KEY}' (PEM format)"
	# squash is necessary to hide the secrets added during docker build.
	docker build --squash -f rhel7.Dockerfile -t ${REPO_NAME}:${GIT_TAG}-rhel7 . --build-arg GIT_TAG=${GIT_TAG}  --build-arg REPO_NAME=${REPO_NAME} --build-arg SUBSCRIPTION_KEY=${SUBSCRIPTION_KEY}
alpine: alpine.Dockerfile
	echo "Building Alpine based image with tag: '${REPO_NAME}:${GIT_TAG}-alpine'"
	docker build -f alpine.Dockerfile -t ${REPO_NAME}:${GIT_TAG}-alpine . --build-arg GIT_TAG=${GIT_TAG}
