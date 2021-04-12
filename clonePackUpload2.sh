#!/usr/bin/env bash

set -e

HOME_PATH="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR=`mktemp -d`
DOCKERFILE_PATH=$HOME_PATH/Dockerfiles

REMOTE_REPO=$1
PROJECT_NAME=$2
BRANCH=$3
NEW_VERSION=$4
PROJECT_PORT=$5

generateDockerfile(){
	PROJECT_NAME=$1
	PROJECT_PORT=$2

    mkdir -p $DOCKERFILE_PATH
	cd $DOCKERFILE_PATH
	# info "正在生成工作目录..."
	if [[ ${PROJECT_NAME} = "cmp-config" ]]
	then
		SERVICE_NAME=${PROJECT_NAME} SERVICE_PORT=${PROJECT_PORT} envsubst < ${DOCKERFILE_PATH}/ConfigDockerfile.tmpl > $DOCKERFILE_PATH/${PROJECT_NAME}.df
	else
		SERVICE_NAME=${PROJECT_NAME} SERVICE_PORT=${PROJECT_PORT} envsubst < ${DOCKERFILE_PATH}/CommonDockerfile.tmpl > $DOCKERFILE_PATH/${PROJECT_NAME}.df
	fi
}

TAG_NAME=${BRANCH}-${NEW_VERSION}

sudo rm -rf $WORK_DIR/$PROJECT_NAME

#generateDockerfile $PROJECT_NAME $PROJECT_PORT

mkdir -p $WORK_DIR
cd $WORK_DIR
git clone $REMOTE_REPO
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME
git checkout $NEW_VERSION

#sed -i "s/dev/k8s/g" src/main/resources/bootstrap.yml
cd ${WORK_DIR}/${PROJECT_NAME}; mvn clean install -Dmaven.test.skip=true
#sudo cp $DOCKERFILE_PATH/${PROJECT_NAME}.df target/Dockerfile

cd ${WORK_DIR}/${PROJECT_NAME}/product-order/target
sudo cp ../Dockerfile .
sudo sh -c 'echo ${NEW_VERSION} > current_version'
docker build -t 172.27.139.253:443/cps/product-order:${TAG_NAME} .
docker push 172.27.139.253:443/cps/product-order:${TAG_NAME}

cd ${WORK_DIR}/${PROJECT_NAME}/product-nas/target
sudo cp ../Dockerfile .
sudo sh -c 'echo ${NEW_VERSION} > current_version'
docker build -t 172.27.139.253:443/cps/product-nas:${TAG_NAME} .
docker push 172.27.139.253:443/cps/product-nas:${TAG_NAME}

cd ${WORK_DIR}/${PROJECT_NAME}/product-ecs/target
sudo cp ../Dockerfile .
sudo sh -c 'echo ${NEW_VERSION} > current_version'
docker build -t 172.27.139.253:443/cps/product-ecs:${TAG_NAME} .
docker push 172.27.139.253:443/cps/product-ecs:${TAG_NAME}

cd ${WORK_DIR}/${PROJECT_NAME}/product-autoscaling/target
sudo cp ../Dockerfile .
sudo sh -c 'echo ${NEW_VERSION} > current_version'
docker build -t 172.27.139.253:443/cps/product-autoscaling:${TAG_NAME} .
docker push 172.27.139.253:443/cps/product-autoscaling:${TAG_NAME}

cd ${WORK_DIR}/${PROJECT_NAME}/product-redis/target
sudo cp ../Dockerfile .
sudo sh -c 'echo ${NEW_VERSION} > current_version'
docker build -t 172.27.139.253:443/cps/product-redis:${TAG_NAME} .
docker push 172.27.139.253:443/cps/product-redis:${TAG_NAME}
