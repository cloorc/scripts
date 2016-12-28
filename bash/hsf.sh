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

#/d/source/directory
local_wd=$PWD/target/$finalName.war
#\\d\\source\\directory
local_wd=${local_wd//\//\\}
local_wd=${local_wd#\\}
local_wd=${local_wd/\\/:}

docker run --name=edas-${PWD##*/} -d -p $1:5005 -v $local_wd:/opt/taobao-tomcat-7.0.59/deploy/$finalName.war  --add-host=jmenv.tbsite.net:$2 --add-host=config.tesir.top:192.168.103.101  index.tenxcloud.com/revolc/edas:latest