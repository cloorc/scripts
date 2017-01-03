#!/usr/bin/env bash

function error() {
	echo -e "\033[31merror $*\033[0m"
}

function exit() {
	echo -e "\033[31mexiting ... $*\033[0m"
}

function usage() {
	echo -e "\033[31musage: ${BASH_SOURCE##*/} [ folder [ repository ] ]\033[0m"
}

trap error ERR
trap exit EXIT

function single() {
    if [ -d $1 ] ;then
        pushd $1
        if [ -d .git ] ;then
        	if [ -z "${2:-}" ] ;then
            	rep="lolegends/`git remote -v|grep "origin\s\+.*\s\+(push)"|awk -F/ '{print $2}'|awk '{print $1}'`"
            else
            	rep=$2
            fi
        	git remote add oschina git@git.oschina.net:$rep
        	git remote -v
        	git push oschina master
        	git remote remove oschina
        fi
        popd
    fi
}

usage

if [ -n "$*" ] ;then
	single $*
elif [ -d .git ] ;then
    single . $*
else
    for d in * ;do
        single $d
    done
fi
