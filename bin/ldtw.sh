#!/bin/sh
if [ -f "$PWD/ldtw.env" ]; then
    log DEBUG loader.sh "loading ldt wrapper environment '$PWD/ldtw.env'"
    export $(cat $PWD/ldtw.env | xargs)
fi
checkDockerCommand=$(command -v docker)
if [ "$checkDockerCommand" = "" ]; then
    echo ">:_ ldt vscode post-install"
    ldt vscode post-install
else
    checkDockerService=$(service docker status | grep is\ running)
    if [ "$checkDockerService" = "" ]; then
        echo ">:_ sudo service docker start"
        sudo service docker start >/dev/null
    fi
fi
if [ ! -d "$PWD/.ldt" ]; then
    wget https://cdn.lildworks.cloud/ldt.tar.gz
    tar -xzvf ldt.tar.gz
fi
if [ ! "$(wget https://cdn.lildworks.cloud/ldt/VERSION)" = "$(cat $PWD/.ldt/VERSION)" ]; then
    wget https://cdn.lildworks.cloud/ldt.tar.gz
    tar -xzvf ldt.tar.gz
fi
eval $PWD/.ldt/bin/ldt.sh $*
