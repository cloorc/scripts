#!/usr/bin/env bash
set -e

function single() {
    if [ -d $1 ] ;then
        pushd $1
        if [ -d .git ] ;then
        	if [ -z "$2" ] ;then
            	rep=`git remote -v|grep "origin\s\+.*\s\+(push)"|awk -F/ '{print $2}'|awk '{print $1}'`
            else
            	rep=$2
            fi
            git remote add oschina git@git.oschina.net:lolegends/$rep
            git push oschina master
            git remote remove oschina
        fi
        popd $1
    fi
}

if [ -d .git ] ;then
    single . $*
elif [ -n "$*" ] ;then
	single $*
else
    for d in * ;do
        single $d
    done
fi
