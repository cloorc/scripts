#!/usr/bin/env bash
set -e

function fatal() {
	echo -e "\033[31m$*\033[0m"
}

function info() {
	echo -e "\033[32m$*\033[0m"
}

[ ! -e target -o ! -d target ] && {
	fatal "Target is not exist or is not a folder."
	exit -1
}

finalName=`mvn help:evaluate -Dexpression=project.build.finalName 2>/dev/null|grep -v "^.*\s.*$"`

[ $? -ne 0 ] && {
	fatal "Cannot retrieve the final name for this artifact."
	exit -1
}

[ ! -e target/$finalName.war ] && {
	fatal "Not a valid hsf application."
	exit -1
}

[ ! -e target/deploy ] && mkdir target/deploy
[ ! -e target/deploy/$finalName.war ] && cp target/$finalName.war target/deploy/$finalName.war

container=edas-${PWD##*/}

count=`docker ps -f name=$container|wc -l`

[ $count -eq 2 ] && docker stop $container

count=`docker ps -af name=$container|wc -l`

[ $count -eq 2 ] && docker rm $container

#/d/source/directory
local_wd=$PWD/target/deploy
#\\d\\source\\directory
local_wd=${local_wd//\//\\}
local_wd=${local_wd#\\}
local_wd=${local_wd/\\/:\\}

info "${local_wd//\\/\\\\}"

docker run --name=$container -d -p $1:5005 -p ${3:-8080}:8080 -v $local_wd:/home/tomcat/deploy -e JAVA_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,address=0.0.0.0:5005,suspend=n,server=y" --add-host=jmenv.tbsite.net:$2 --add-host=config.tesir.top:192.168.103.101  docker.tesir.top/ci/taobao-tomcat:v1.1