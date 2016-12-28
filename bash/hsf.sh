#!/usr/bin/env bash
set -e

command_name=${0%.*}
command_name=${command_name##*/}
cmd=${1}
registry_ip=${2:-192.168.103.108}
debug_port=${3:-5005}
web_port=${4:-8080}

if [ $# -le 3 ]
then
    shift $#
else
    shift 4
fi
options=${*:-}

function usage() {
    info "$command_name {stop|logs|start {registry-ip-address} [debug-port] [web-port] [options...]}"
}

function fatal() {
    echo -e "\033[31m$*\033[0m"
    usage
}

function info() {
    echo -e "\033[32m$*\033[0m"
}

function stop() {
    info "Trying to stop container: $1 ...";
    count=`docker ps -f name=$1|wc -l`;
    [ $count -eq 2 ] && docker stop $1;
    count=`docker ps -af name=$1|wc -l`;
    [ $count -eq 2 ] && docker rm $1;
    return 0
}

info "Working with command: $cmd $registry_ip $debug_port $web_port $options";
container=edas-${PWD##*/};

case $cmd in
    stop)
        stop $container;
        ;;
    logs)
        docker logs -f $container;
        ;;
    start)
        stop $container
        if [ ! -e target -o ! -d target ] ;then
            fatal "Target is not exist or is not a folder."
            exit -1
        fi

        finalName=`mvn help:evaluate -Dexpression=project.build.finalName 2>/dev/null|grep -v "^.*\s.*$"`

        [ $? -ne 0 ] && {
            fatal "Cannot retrieve the final name for this artifact."
            exit -1
        }

        [ ! -e target/$finalName.war ] && {
            fatal "Not a valid hsf application."
            exit -1
        }

        [ ! -e target/deploy ] && mkdir target/deploy;
        [ ! -e target/deploy/$finalName.war ] && cp target/$finalName.war target/deploy/$finalName.war;

        #/d/source/directory
        local_wd=$PWD/target/deploy;
        #\\d\\source\\directory
        local_wd=${local_wd//\//\\};
        local_wd=${local_wd#\\};
        local_wd=${local_wd/\\/:\\};

        info "${local_wd//\\/\\\\}";

        docker run --name=$container -d -p $debug_port:5005 -p $web_port:8080 -v $local_wd:/home/tomcat/deploy -e JAVA_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,address=0.0.0.0:5005,suspend=n,server=y" --add-host=jmenv.tbsite.net:$registry_ip --add-host=config.tesir.top:192.168.103.101 $options docker.tesir.top/ci/taobao-tomcat:v1.1;
        ;;
    *)
        usage
        ;;
esac
