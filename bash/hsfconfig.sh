#!/usr/bin/env bash
set -e

if [ -n "${HSF_PORT}" -o -n "${HSF_HTTP_PORT}" ] ;then
    pushd /tmp
    jar -xvf /root/taobao-hsf.sar/plugins/hsf.jar.plugin lib/hsf.app.spring-2.1.1.3.jar
    jar -xvf lib/hsf.app.spring-2.1.1.3.jar hsfconfig.properties
    if [ -n "${HSF_PORT}" ] ;then
        sed -i "s/hsf.server.port=.*$/hsf.server.port=${HSF_PORT}/g" hsfconfig.properties
    fi
    if [ -n "${HSF_HTTP_PORT}" ] ;then
        grep -q "hsf.http.port" hsfconfig.properties
        if [ $? -eq 0 ] ;then
            sed -i "s/hsf.http.port=.*$/hsf.http.port=${HSF_HTTP_PORT}/g" hsfconfig.properties
        else
            echo "hsf.http.port=${HSF_HTTP_PORT}" >> hsfconfig.properties
        fi
    fi
    jar -uvf lib/hsf.app.spring-2.1.1.3.jar hsfconfig.properties
    rm -rf hsfconfig.properties
    jar -uvf /root/taobao-hsf.sar/plugins/hsf.jar.plugin lib/hsf.app.spring-2.1.1.3.jar
    rm -rf lib
    popd
fi

sh /root/run.sh
