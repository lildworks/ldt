#!/bin/bash
main() {
    parse_args $*
    load_context
    validate_args
    eval_args
    validate_commands
    eval_commands
}
parse_args() {
    LDT__ROOT="$(dirname "$(realpath "$0")")"
    LDT__VERSION=$(cat $LDT__ROOT/../VERSION)
    args=()
    for arg in $@; do
        case $arg in
        -d | --debug)
            LDT__DEBUG_MODE=enabled
            ;;
        -h | --help)
            args+=("core")
            args+=("print-help")
            ;;
        -v | --version)
            args+=("core")
            args+=("print-version")
            ;;
        --container-env)
            LDT_DOCKER__CONTIANER_ENV_FLAG=true
            ;;
        --container-image)
            LDT_DOCKER__CONTIANER_IMAGE_FLAG=true
            ;;
        --container-name)
            LDT_DOCKER__CONTAINER_NAME_FLAG=true
            ;;
        --container-network)
            LDT_DOCKER__CONTAINER_NETWORK_FLAG=true
            ;;
        --container-port)
            LDT_DOCKER__CONTAINER_PORT_FLAG=true
            ;;
        --container-user)
            LDT_DOCKER__CONTAINER_USER_FLAG=true
            ;;
        --container-volume)
            LDT_DOCKER__CONTAINER_VOLUME_FLAG=true
            ;;
        --docker-access-token)
            LDT_DOCKER__ACCESS_TOKEN_FLAG=true
            ;;
        --docker-registry)
            LDT_DOCKER__REGISTRY_FLAG=true
            ;;
        --docker-private-registry)
            LDT_DOCKER__REGISTRY_PRIVATE=true
            ;;
        --docker-repository)
            LDT_DOCKER__REPOSITORY_FLAG=true
            ;;
        --docker-username)
            LDT_DOCKER__USERNAME_FLAG=true
            ;;
        --vscode-docker-engine-version)
            LDT_VSCODE__DOCKER_ENGINE_VERSION_FLAG=true
            ;;
        --vscode-java-version)
            LDT_VSCODE__JAVA_VERSION_FLAG=true
            ;;
        --vscode-nodejs-version)
            LDT_VSCODE__NODEJS_VERSION_FLAG=true
            ;;
        --vscode-openvpn-version)
            LDT_VSCODE__OPENVPN_VERSION_FLAG=true
            ;;
        *)
            if [ "$LDT_DOCKER__CONTIANER_ENV_FLAG" = "true" ]; then
                LDT_DOCKER__CONTIANER_ENV_FLAG=false
                LDT_DOCKER__CONTIANER_ENV=$arg
                continue
            fi
            if [ "$LDT_DOCKER__CONTIANER_IMAGE_FLAG" = "true" ]; then
                LDT_DOCKER__CONTIANER_IMAGE_FLAG=false
                LDT_DOCKER__CONTIANER_IMAGE=$arg
                continue
            fi
            if [ "$LDT_DOCKER__CONTAINER_NAME_FLAG" = "true" ]; then
                LDT_DOCKER__CONTAINER_NAME_FLAG=false
                LDT_DOCKER__CONTAINER_NAME=$arg
                continue
            fi
            if [ "$LDT_DOCKER__CONTAINER_NETWORK_FLAG" = "true" ]; then
                LDT_DOCKER__CONTAINER_NETWORK_FLAG=false
                LDT_DOCKER__CONTAINER_NETWORK=$arg
                continue
            fi
            if [ "$LDT_DOCKER__CONTAINER_PORT_FLAG" = "true" ]; then
                LDT_DOCKER__CONTAINER_PORT_FLAG=false
                LDT_DOCKER__CONTAINER_PORT=$arg
                continue
            fi
            if [ "$LDT_DOCKER__CONTAINER_USER_FLAG" = "true" ]; then
                LDT_DOCKER__CONTAINER_USER_FLAG=false
                LDT_DOCKER__CONTAINER_USER=$arg
                continue
            fi
            if [ "$LDT_DOCKER__CONTAINER_VOLUME_FLAG" = "true" ]; then
                LDT_DOCKER__CONTAINER_VOLUME_FLAG=false
                LDT_DOCKER__CONTAINER_VOLUME=$arg
                continue
            fi
            if [ "$LDT_DOCKER__ACCESS_TOKEN_FLAG" = "true" ]; then
                LDT_DOCKER__ACCESS_TOKEN_FLAG=false
                LDT_DOCKER__ACCESS_TOKEN=$arg
                continue
            fi
            if [ "$LDT_DOCKER__REGISTRY_FLAG" = "true" ]; then
                LDT_DOCKER__REGISTRY_FLAG=false
                LDT_DOCKER__REGISTRY=$arg
                continue
            fi
            if [ "$LDT_DOCKER__REPOSITORY_FLAG" = "true" ]; then
                LDT_DOCKER__REPOSITORY_FLAG=false
                LDT_DOCKER__REPOSITORY=$arg
                continue
            fi
            if [ "$LDT_DOCKER__USERNAME_FLAG" = "true" ]; then
                LDT_DOCKER__USERNAME_FLAG=false
                LDT_DOCKER__USERNAME=$arg
                continue
            fi
            if [ "$LDT_VSCODE__DOCKER_ENGINE_VERSION_FLAG" = "true" ]; then
                LDT_VSCODE__DOCKER_ENGINE_VERSION_FLAG=false
                LDT_VSCODE__DOCKER_ENGINE_VERSION=$arg
                continue
            fi
            if [ "$LDT_VSCODE__JAVA_VERSION_FLAG" = "true" ]; then
                LDT_VSCODE__JAVA_VERSION_FLAG=false
                LDT_VSCODE__JAVA_VERSION=$arg
                continue
            fi
            if [ "$LDT_VSCODE__NODEJS_VERSION_FLAG" = "true" ]; then
                LDT_VSCODE__NODEJS_VERSION_FLAG=false
                LDT_VSCODE__NODEJS_VERSION=$arg
                continue
            fi
            if [ "$LDT_VSCODE__OPENVPN_VERSION_FLAG" = "true" ]; then
                LDT_VSCODE__OPENVPN_VERSION_FLAG=false
                LDT_VSCODE__OPENVPN_VERSION=$arg
                continue
            fi
            args+=($arg)
            ;;
        esac
    done
}
log() {
    logLevel=$1
    shift
    loggerClazz=$1
    shift
    if [ "$logLevel" = "DEBUG" ] && [ "$LDT__DEBUG_MODE" = "enabled" ]; then
        echo "$(date '+%F %T.%3N') LDT [DEBUG] $loggerClazz -- $*"
    fi
    if [ "$logLevel" = "INFO" ] && [ "$LDT__DEBUG_MODE" = "enabled" ]; then
        echo "$(date '+%F %T.%3N') LDT [ INFO] $loggerClazz -- $*"
    fi
    if [ "$logLevel" = "WARN" ]; then
        echo "$(date '+%F %T.%3N') LDT [ WARN] $loggerClazz -- $*"
    fi
    if [ "$logLevel" = "ERROR" ]; then
        echo "$(date '+%F %T.%3N') LDT [ERROR] $loggerClazz -- $*"
    fi
}
load_context() {
    if [ -f "$PWD/.env" ]; then
        log DEBUG loader.sh "loading ldt environment '$PWD/.env'"
        export $(cat $PWD/.env | xargs)
    fi
}
validate_args() {
    if [ "${args[0]}" = "" ]; then
        log ERROR validator.sh "invalid command"
        exit 1
    fi
}
validate_commands() {
    if [ "$cmd" = "" ]; then
        log ERROR validator.sh "unknown command"
        exit 1
    fi
    if [ "$cmd" = "exit" ]; then
        exit 0
    fi
}
eval_args() {
    eval ${args[@]}
}
## TODO [lild] ldt context separations for running commands evaulation
eval_commands() {
    log INFO docker-wrapper.sh running...
    run $dockerEngine $dockerContext $dockerPublish $dockerImage $cmd
}
run() {
    printf ">:_ pwd='$PWD'\n"
    printf ">:_ cmd='$*'\n"
    eval $*
}
core() {
    if [ "$1" = "print-help" ]; then
        printf "===========================================================================\n"
        printf "USAGE: ldt [core|<dockerw|docker-wrapper>] [command] <arg(s)>\n"
        printf "\n"
        printf "command(s):\n"
        printf "  adminjs        -  run adminjs based development container in a wrapped docker context\n"
        printf "  dockerize      -  run dockerize scripts for project in a project based type wrapped docker context\n"
        printf "  gradle         -  run gradle based development container in a wrapped docker context\n"
        printf "  httpserver     -  run httpserver based development container in a wrapped docker context\n"
        printf "  make           -  run make based development container in a wrapped docker context\n"
        printf "  mysql          -  run mysql based development container in a wrapped docker context\n"
        printf "  nginx          -  run nginx based development container in a wrapped docker context\n"
        printf "  ng             -  run angular based development container in a wrapped docker context\n"
        printf "  npm            -  run npm based development container in a wrapped docker context\n"
        printf "  php            -  run php based development container in a wrapped docker context\n"
        printf "  phpfpm         -  run php with fpm based development container in a wrapped docker context\n"
        printf "  postgres       -  run postgres based development container in a wrapped docker context\n"
        printf "  print-help     -  prints the help message to the standard output in core context\n"
        printf "  print-version  -  prints the version to the standard output in core context\n"
        printf "  rabbitmq       -  run rabbitmq based development container in a wrapped docker context\n"
        printf "  react          -  run react based development container in a wrapped docker context\n"
        printf "  vscode         -  run pre-defined unix scripts in code-server cloud context\n"
        printf "  webpack        -  run webpack based development container in a wrapped docker context\n"
        printf "\n"
        printf "arg(s):\n"
        printf "  -d|--debug     -  during the script run, enables the debug mode with verbose messages\n"
        printf "  -v|--version   -  run print-version command and prints the current version\n"
        printf "  -h|--help      -  run print-help command and prints the help message\n"
        printf "\n"
        cmd="exit"
    fi
    if [ "$1" = "print-version" ]; then
        printf "ldt version $LDT__VERSION\n"
        cmd="exit"
    fi
}
project() {
    if [ "$1" = ".dockerignore" ]; then
        cp -fv $LDT__ROOT/../res/docker/.dockerignore $PWD/
        cmd="exit"
    fi
    if [ "$1" = ".gitignore" ]; then
        cp -fv $LDT__ROOT/../res/git/.gitignore $PWD/
        cmd="exit"
    fi
    if [ "$1" = ".npmignore" ]; then
        cp -fv $LDT__ROOT/../res/npm/.npmignore $PWD/
        cmd="exit"
    fi
    if [ "$1" = "Dockerfile" ]; then
        if [ -f $PWD/angular.json ]; then
            cp -fv $LDT__ROOT/../res/dockerfile/anguboot/nginx/stable/Dockerfile $PWD/
        fi
        if [ -f $PWD/build.gradle ]; then
            cp -fv $LDT__ROOT/../res/dockerfile/springboot/jre21/Dockerfile $PWD/
        fi
        cmd="exit"
    fi
    if [ "$1" = "proxy-conf.json" ]; then
        if [ -f $PWD/angular.json ]; then
            mkdir -p $PWD/config/proxy/
            cp -fv $LDT__ROOT/../res/ng/anguboot/proxy-conf.json.example $PWD/config/proxy/proxy-conf.json
        fi
        cmd="exit"
    fi
}
gitscm() {
    if [ "$1" = "init" ]; then
        LDT__GITSCM_USERNAME=$2
        LDT__GITSCM_EMAIL=$3
        git init
        git config user.name $LDT__GITSCM_USERNAME
        git config user.email $LDT__GITSCM_EMAIL
        git flow init -d
        git tag 0.0.0
        cmd="exit"
    fi
    if [ "$1" = "fetch" ]; then
        git fetch --all --prune --tags
        cmd="exit"
    fi
    if [ "$1" = "push" ]; then
        git push --all --set-upstream
        git push --tags
        cmd="exit"
    fi
    if [ "$1" = "submodule-add" ]; then
        LDT__GITSCM_SUBMODULE_NAME=$2
        LDT__GITSCM_SUBMODULE_REPOSITORY=$3
        LDT__GITSCM_SUBMODULE_PATH=$4
        git submodule add --name $LDT__GITSCM_SUBMODULE_NAME -- $LDT__GITSCM_SUBMODULE_REPOSITORY $LDT__GITSCM_SUBMODULE_PATH
        cmd="exit"
    fi
    if [ "$1" = "submodule-sync" ]; then
        git submodule update --init --recursive
        git submodule sync --recursive
        cmd="exit"
    fi
    if [ "$1" = "submodule-delete" ]; then
        LDT__GITSCM_SUBMODULE_NAME=$2
        LDT__GITSCM_SUBMODULE_PATH=$3
        git submodule deinit -f -- $LDT__GITSCM_SUBMODULE_PATH
        rm -rf .git/modules/$LDT__GITSCM_SUBMODULE_NAME
        git rm -rf $LDT__GITSCM_SUBMODULE_PATH
        cmd="exit"
    fi
    if [ "$1" = "release-start" ]; then
        LDT__GITSCM_RELEASE_VERSION=$2
        git flow release start $LDT__GITSCM_RELEASE_VERSION
        cmd="exit"
    fi
    if [ "$1" = "release-finish" ]; then
        LDT__GITSCM_RELEASE_VERSION=$2
        git flow release finish $LDT__GITSCM_RELEASE_VERSION
        git push --all --set-upstream
        git push --tags
        if [ ! "$LDT__GITSCM_RELEASE_VERSION" = "" ]; then
            git checkout $LDT__GITSCM_RELEASE_VERSION
        fi
        cmd="exit"
    fi
}
webpack() {
    if [ "$LDT_DOCKER__CONTAINER_PORT" = "" ]; then LDT_DOCKER__CONTAINER_PORT=3000; fi

    if [ "$1" = "cache-clear" ] ||
        [ "$1" = "install" ] ||
        [ "$1" = "update" ] ||
        [ "$1" = "run" ] ||
        [ "$1" = "build" ] ||
        [ "$1" = "lint" ] ||
        [ "$1" = "test" ] ||
        [ "$1" = "dist" ] ||
        [ "$1" = "dockerize" ]; then
        npm $*
    fi
    if [ "$1" = "start" ]; then
        shift
        dockerPublish="-p $LDT_DOCKER__CONTAINER_PORT:3000"
        cmd="npm run webpack -- --mode development --watch $*"
        npm "start:webpack"
    fi
}
sb() {
    if [ "$LDT_DOCKER__CONTAINER_PORT" = "" ]; then LDT_DOCKER__CONTAINER_PORT=9080; fi

    if [ "$1" = "cache-clear" ] ||
        [ "$1" = "install" ] ||
        [ "$1" = "update" ] ||
        [ "$1" = "run" ] ||
        [ "$1" = "build" ] ||
        [ "$1" = "check" ] ||
        [ "$1" = "test" ] ||
        [ "$1" = "dist" ] ||
        [ "$1" = "dockerize" ]; then
        gradle $*
    fi
    if [ "$1" = "start" ]; then
        shift
        dockerPublish="-p $LDT_DOCKER__CONTAINER_PORT:9080"
        cmd="gradle bootRun $*"
        gradle "start:sb"
    fi
    if [ "$1" = "start-debug" ]; then
        shift
        dockerPublish="-p $LDT_DOCKER__CONTAINER_PORT:9080 -p 5005:5005"
        cmd="gradle bootRun -Dagentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=0.0.0.0:5005 $*"
        gradle "start:sb"
    fi
}
gradle() {
    if [ "$GRADLE_HOME" = "" ]; then GRADLE_HOME="/usr/src/.gradle"; fi

    if [ "$dockerImage" = "" ] && [ ! "$LDT_DOCKER__CONTIANER_IMAGE" = "" ]; then
        dockerImage=$LDT_DOCKER__CONTIANER_IMAGE
    fi
    if [ "$dockerImage" = "" ] && [ ! "$DOCKER_IMAGE_GRADLE" = "" ]; then
        dockerImage=$DOCKER_IMAGE_GRADLE
    fi
    if [ "$dockerImage" = "" ]; then
        dockerImage=gradle:latest
    fi
    dockerEngine="docker run -it --rm"
    dockerContext=""
    if [ ! "$LDT_DOCKER__CONTAINER_NAME" = "" ]; then
        dockerContext="$dockerContext --name $LDT_DOCKER__CONTAINER_NAME"
    fi
    if [ ! "$LDT_DOCKER__CONTAINER_NETWORK" = "" ]; then
        dockerContext="$dockerContext --network $LDT_DOCKER__CONTAINER_NETWORK"
    else
        dockerContext="$dockerContext --network host"
    fi
    if [ ! "$LDT_DOCKER__CONTAINER_USER" = "" ]; then
        dockerContext="$dockerContext -u $LDT_DOCKER__CONTAINER_USER"
    else
        dockerContext="$dockerContext -u $(id -u):$(id -g)"
    fi
    dockerContext="$dockerContext -v $PWD:/usr/src"
    dockerContext="$dockerContext -v $PWD/.gradle:/config"
    dockerContext="$dockerContext -v /etc/group:/etc/group"
    dockerContext="$dockerContext -v /etc/passwd:/etc/passwd"
    if [ ! "$LDT_DOCKER__CONTAINER_VOLUME" = "" ]; then
        IFS=',' read -ra LDT_DOCKER__CONTAINER_VOLUME <<<"$LDT_DOCKER__CONTAINER_VOLUME"
        for i in "${LDT_DOCKER__CONTAINER_VOLUME[@]}"; do
            dockerContext="$dockerContext -v $i"
        done
    fi
    dockerContext="$dockerContext -w /usr/src"
    dockerContext="$dockerContext -e HOME=$GRADLE_HOME"
    dockerContext="$dockerContext -e GRADLE_HOME=$GRADLE_HOME"
    dockerContext="$dockerContext -e GRADLE_USER_HOME=$GRADLE_HOME"
    if [ ! "$LDT_DOCKER__CONTIANER_ENV" = "" ]; then
        IFS=',' read -ra LDT_DOCKER__CONTIANER_ENV <<<"$LDT_DOCKER__CONTIANER_ENV"
        for i in "${LDT_DOCKER__CONTIANER_ENV[@]}"; do
            dockerContext="$dockerContext -e $i"
        done
    fi
    if [ "$1" = "cache-clear" ]; then
        cmd="rm -rfv"
        cmd="$cmd .gradle/ lib/**/.gradle/"
        cmd="$cmd bin/ lib/**/bin/"
        cmd="$cmd build/ lib/**/build/"
        cmd="$cmd dist/ lib/**/dist/"
    fi
    if [ "$1" = "install" ] ||
        [ "$1" = "update" ]; then
        shift
        cmd="gradle --refresh-dependencies --warning-mode all --info $*"
    fi
    if [ "$1" = "run" ]; then
        shift
        if [ "$*" = "" ]; then
            cmd="/bin/bash"
        else
            cmd="/bin/bash -c \"$*\""
        fi
    fi
    if [ "$1" = "start" ]; then
        shift
        cmd="gradle bootRun $*"
    fi
    if [ "$1" = "build" ]; then
        shift
        cmd="gradle build -x check -x test $*"
    fi
    if [ "$1" = "check" ]; then
        shift
        cmd="gradle check -x build -x test $*"
    fi
    if [ "$1" = "sonar" ]; then
        shift
        dockerContext="$dockerContext -e SONAR_HOST_URL=$SONAR_HOST_URL"
        dockerContext="$dockerContext -e SONAR_TOKEN=$SONAR_TOKEN"
        cmd="gradle sonar $*"
    fi
    if [ "$1" = "test" ]; then
        shift
        cmd="gradle test -x build -x check $*"
    fi
    if [ "$1" = "dist" ]; then
        projectName=$(docker run -i --rm $dockerContext $dockerImage /bin/bash -c "gradle -q properties | awk -F': ' '/^name:/ {print \$2}'")
        projectVersion=$(docker run -i --rm $dockerContext $dockerImage /bin/bash -c "gradle -q properties | awk -F': ' '/^version:/ {print \$2}'")
        mkdir -p dist/docs/
        docker run -i --rm $dockerContext $dockerImage /bin/bash -c "gradle javadoc"
        if [ -d "build/docs/javadoc/" ]; then cp -R build/docs/javadoc/ dist/docs/; fi
        if [ -d "build/generated-docs/" ]; then cp -R build/generated-docs/ dist/docs/; fi
        mkdir -p dist/libs/
        appJarFile="${projectName}-${projectVersion}.jar"
        if [ -f "build/libs/${appJarFile}" ]; then cp build/libs/${appJarFile} dist/libs/application.jar; fi
        libJarFile="${projectName}-${projectVersion}-plain.jar"
        if [ -f "build/libs/${libJarFile}" ]; then cp build/libs/${libJarFile} dist/libs/${projectName}-${projectVersion}.jar; fi
        if [ ! "${projectVersion}" = "" ]; then echo $projectVersion >dist/VERSION; fi
        if [ -f CHANGELOG.md ]; then cp CHANGELOG.md dist/CHANGELOG.md; fi
        if [ -f LICENSE ]; then cp LICENSE dist/LICENSE.txt; fi
        cmd="exit"
    fi
    if [ "$1" = "dockerize" ]; then
        projectName=$(docker run -i --rm $dockerContext $dockerImage /bin/bash -c "gradle -q properties | awk -F': ' '/^name:/ {print \$2}'")
        projectVersion=$(docker run -i --rm $dockerContext $dockerImage /bin/bash -c "gradle -q properties | awk -F': ' '/^version:/ {print \$2}'")
        projectCommitId=$(docker run -i --rm $dockerContext $dockerImage /bin/bash -c "git rev-parse --short HEAD")
        shift
        dockerize $*
        cmd="exit"
    fi
}
pgadmin() {
    if [ "$dockerImage" = "" ] && [ ! "$LDT_DOCKER__CONTIANER_IMAGE" = "" ]; then
        dockerImage=$LDT_DOCKER__CONTIANER_IMAGE
    fi
    if [ "$dockerImage" = "" ] && [ ! "$DOCKER_IMAGE_PGADMIN" = "" ]; then
        dockerImage=$DOCKER_IMAGE_PGADMIN
    fi
    if [ "$dockerImage" = "" ]; then
        dockerImage=dpage/pgadmin4:latest
    fi
    dockerEngine="docker run -it --rm"
    dockerContext=""
    if [ ! "$LDT_DOCKER__CONTAINER_NAME" = "" ]; then
        dockerContext="$dockerContext --name $LDT_DOCKER__CONTAINER_NAME"
    else
        dockerContext="$dockerContext --name pgadmin"
    fi
    if [ ! "$LDT_DOCKER__CONTAINER_NETWORK" = "" ]; then
        dockerContext="$dockerContext --network $LDT_DOCKER__CONTAINER_NETWORK"
    else
        checkNetwork=$(docker network ls | grep postgres)
        if [ ! "$checkNetwork" = "" ]; then
            dockerContext="$dockerContext --network postgres"
        fi
    fi
    if [ ! "$LDT_DOCKER__CONTAINER_VOLUME" = "" ]; then
        IFS=',' read -ra LDT_DOCKER__CONTAINER_VOLUME <<<"$LDT_DOCKER__CONTAINER_VOLUME"
        for i in "${LDT_DOCKER__CONTAINER_VOLUME[@]}"; do
            dockerContext="$dockerContext -v $i"
        done
    else
        dockerContext="$dockerContext -v $PWD/pgadmin:/var/lib/pgadmin"
    fi
    dockerContext="$dockerContext -u root"
    dockerContext="$dockerContext -e PGADMIN_DEFAULT_EMAIL=root@pgadmin.org"
    dockerContext="$dockerContext -e PGADMIN_DEFAULT_PASSWORD=pgadmin"

    if [ ! "$LDT_DOCKER__CONTIANER_ENV" = "" ]; then
        IFS=',' read -ra LDT_DOCKER__CONTIANER_ENV <<<"$LDT_DOCKER__CONTIANER_ENV"
        for i in "${LDT_DOCKER__CONTIANER_ENV[@]}"; do
            dockerContext="$dockerContext -e $i"
        done
    fi

    if [ "$1" = "start" ]; then
        dockerPublish="-p 5050:80"
        cmd=" "
    fi
}
postgres() {
    if [ "$LDT_DOCKER__CONTAINER_NETWORK" = "" ]; then LDT_DOCKER__CONTAINER_NETWORK=postgres; fi
    checkNetwork=$(docker network ls | grep $LDT_DOCKER__CONTAINER_NETWORK)
    if [ "$checkNetwork" = "" ]; then
        docker network create $LDT_DOCKER__CONTAINER_NETWORK
    fi
    if [ "$dockerImage" = "" ] && [ ! "$LDT_DOCKER__CONTIANER_IMAGE" = "" ]; then
        dockerImage=$LDT_DOCKER__CONTIANER_IMAGE
    fi
    if [ "$dockerImage" = "" ] && [ ! "$DOCKER_IMAGE_POSTGRES" = "" ]; then
        dockerImage=$DOCKER_IMAGE_POSTGRES
    fi
    if [ "$dockerImage" = "" ]; then
        dockerImage=postgres:latest
    fi
    dockerEngine="docker run -it --rm"
    dockerContext=""
    if [ ! "$LDT_DOCKER__CONTAINER_NAME" = "" ]; then
        dockerContext="$dockerContext --name $LDT_DOCKER__CONTAINER_NAME"
    else
        dockerContext="$dockerContext --name postgres"
    fi
    if [ ! "$LDT_DOCKER__CONTAINER_NETWORK" = "" ]; then
        dockerContext="$dockerContext --network $LDT_DOCKER__CONTAINER_NETWORK"
    else
        dockerContext="$dockerContext --network postgres"
    fi
    if [ ! "$LDT_DOCKER__CONTAINER_VOLUME" = "" ]; then
        IFS=',' read -ra LDT_DOCKER__CONTAINER_VOLUME <<<"$LDT_DOCKER__CONTAINER_VOLUME"
        for i in "${LDT_DOCKER__CONTAINER_VOLUME[@]}"; do
            dockerContext="$dockerContext -v $i"
        done
    else
        dockerContext="$dockerContext -v $PWD/postgresql:/var/lib/postgresql"
    fi
    dockerContext="$dockerContext -e POSTGRES_USER=postgres"
    dockerContext="$dockerContext -e POSTGRES_PASSWORD=postgres"

    if [ "$1" = "start" ]; then
        dockerPublish="-p 5432:5432"
        cmd="postgres -c shared_preload_libraries=pg_stat_statements -c pg_stat_statements.track=all -c max_connections=100"
    fi
}
react() {
    if [ "$LDT_DOCKER__CONTAINER_PORT" = "" ]; then LDT_DOCKER__CONTAINER_PORT=5173; fi

    if [ "$1" = "cache-clear" ] ||
        [ "$1" = "install" ] ||
        [ "$1" = "update" ] ||
        [ "$1" = "run" ] ||
        [ "$1" = "build" ] ||
        [ "$1" = "lint" ] ||
        [ "$1" = "test" ] ||
        [ "$1" = "dist" ] ||
        [ "$1" = "dockerize" ]; then
        npm $*
    fi
    if [ "$1" = "start" ]; then
        shift
        dockerPublish="-p $LDT_DOCKER__CONTAINER_PORT:5173"
        cmd="npm run start -- --host 0.0.0.0 --port 5173 --mode development $*"
        npm "start:react"
    fi
}
npm() {
    if [ "$NPM_HOME" = "" ]; then NPM_HOME="/usr/src/.npm"; fi

    if [ "$dockerImage" = "" ] && [ ! "$LDT_DOCKER__CONTIANER_IMAGE" = "" ]; then
        dockerImage=$LDT_DOCKER__CONTIANER_IMAGE
    fi
    if [ "$dockerImage" = "" ] && [ ! "$DOCKER_IMAGE_NODE" = "" ]; then
        dockerImage=$DOCKER_IMAGE_NODE
    fi
    if [ "$dockerImage" = "" ]; then
        dockerImage=node:latest
    fi
    dockerEngine="docker run -it --rm"
    dockerContext=""
    if [ ! "$LDT_DOCKER__CONTAINER_NAME" = "" ]; then
        dockerContext="$dockerContext --name $LDT_DOCKER__CONTAINER_NAME"
    fi
    if [ ! "$LDT_DOCKER__CONTAINER_USER" = "" ]; then
        dockerContext="$dockerContext -u $LDT_DOCKER__CONTAINER_USER"
    else
        dockerContext="$dockerContext -u $(id -u):$(id -g)"
    fi
    dockerContext="$dockerContext -v $PWD:/usr/src"
    dockerContext="$dockerContext -v /etc/group:/etc/group"
    dockerContext="$dockerContext -v /etc/passwd:/etc/passwd"
    if [ ! "$LDT_DOCKER__CONTAINER_VOLUME" = "" ]; then
        IFS=',' read -ra LDT_DOCKER__CONTAINER_VOLUME <<<"$LDT_DOCKER__CONTAINER_VOLUME"
        for i in "${LDT_DOCKER__CONTAINER_VOLUME[@]}"; do
            dockerContext="$dockerContext -v $i"
        done
    fi
    dockerContext="$dockerContext -w /usr/src"
    dockerContext="$dockerContext -e HOME=$NPM_HOME"
    dockerContext="$dockerContext -e NPM_HOME=$NPM_HOME"
    dockerContext="$dockerContext -e NPM_USER_HOME=$NPM_HOME"
    if [ ! "$LDT_DOCKER__CONTIANER_ENV" = "" ]; then
        IFS=',' read -ra LDT_DOCKER__CONTIANER_ENV <<<"$LDT_DOCKER__CONTIANER_ENV"
        for i in "${LDT_DOCKER__CONTIANER_ENV[@]}"; do
            dockerContext="$dockerContext -e $i"
        done
    fi
    if [ "$1" = "cache-clear" ]; then
        cmd="rm -rfv"
        cmd="$cmd .angular/ lib/**/.angular/"
        cmd="$cmd .npm/ lib/**/.npm/"
        cmd="$cmd .node/ lib/**/.node/"
        cmd="$cmd dist/ lib/**/dist/"
        cmd="$cmd node_modules/ lib/**/node_modules/"
        cmd="$cmd package-lock.json lib/**/package-lock.json"
    fi
    if [ "$1" = "install" ]; then
        shift
        cmd="npm install $*"
    fi
    if [ "$1" = "update" ]; then
        shift
        cmd="npm update $*"
    fi
    if [ "$1" = "run" ]; then
        shift
        if [ "$*" = "" ]; then
            cmd="/bin/bash"
        else
            cmd="/bin/bash -c \"$*\""
        fi
    fi
    if [ "$1" = "start" ]; then
        shift
        if [ "$*" = "" ]; then
            cmd="npm run start"
        else
            cmd="npm run start -- $*"
        fi
    fi
    if [ "$1" = "build" ]; then
        shift
        if [ "$*" = "" ]; then
            cmd="npm run build"
        else
            cmd="npm run build -- $*"
        fi
    fi
    if [ "$1" = "lint" ]; then
        shift
        if [ "$*" = "" ]; then
            cmd="npm run lint"
        else
            cmd="npm run lint -- $*"
        fi
    fi
    if [ "$1" = "test" ]; then
        shift
        if [ "$*" = "" ]; then
            cmd="npm run test"
        else
            cmd="npm run test -- $*"
        fi
    fi
    if [ "$1" = "dist" ]; then
        projectName=$(docker run -i --rm $dockerContext $dockerImage /bin/bash -c "node -p -e \"require('./package.json').name\"")
        projectVersion=$(docker run -i --rm $dockerContext $dockerImage /bin/bash -c "node -p -e \"require('./package.json').version\"")
        mkdir -p dist/docs/
        if [ -f config/tsdoc.json ]; then npx compodoc -p config/tsdoc.json -d dist/docs/; fi
        mkdir -p dist/conf/
        if [ -f config/nginx.conf ]; then cp config/nginx.conf dist/conf/nginx.conf; fi
        if [ ! "${projectVersion}" = "" ]; then echo $projectVersion >dist/VERSION; fi
        if [ -f CHANGELOG.md ]; then cp CHANGELOG.md dist/CHANGELOG.md; fi
        if [ -f LICENSE ]; then cp LICENSE dist/LICENSE.txt; fi
        cmd="exit"
    fi
    if [ "$1" = "dockerize" ]; then
        projectName=$(docker run -i --rm $dockerContext $dockerImage /bin/bash -c "node -p -e \"require('./package.json').name\"")
        projectVersion=$(docker run -i --rm $dockerContext $dockerImage /bin/bash -c "node -p -e \"require('./package.json').version\"")
        projectCommitId=$(docker run -i --rm $dockerContext $dockerImage /bin/bash -c "git rev-parse --short HEAD")
        shift
        dockerize $*
        cmd="exit"
    fi
}
ng() {
    if [ "$LDT_DOCKER__CONTAINER_PORT" = "" ]; then LDT_DOCKER__CONTAINER_PORT=4200; fi

    if [ "$1" = "cache-clear" ] ||
        [ "$1" = "install" ] ||
        [ "$1" = "update" ] ||
        [ "$1" = "run" ] ||
        [ "$1" = "build" ] ||
        [ "$1" = "lint" ] ||
        [ "$1" = "test" ] ||
        [ "$1" = "dist" ] ||
        [ "$1" = "dockerize" ]; then
        npm $*
    fi
    if [ "$1" = "start" ]; then
        shift
        dockerPublish="-p $LDT_DOCKER__CONTAINER_PORT:4200"
        cmd="npm run start -- --host 0.0.0.0 --port 4200 $*"
        npm "start:ng"
    fi
}
vscode() {
    if [ "$1" = "cache-clear" ]; then
        cmd="sudo rm -rf"
        cmd="$cmd /config/.cache"
        cmd="$cmd /config/.local/share/mc"
        cmd="$cmd /config/.local/share/nano"
        cmd="$cmd /config/.config/mc"
        cmd="$cmd /config/.config/nano"
        cmd="$cmd /config/.docker"
        cmd="$cmd /config/.gradle"
        cmd="$cmd /config/.java"
        cmd="$cmd /config/.npm"
        cmd="$cmd /config/.bash_history"
        cmd="$cmd /config/.testcontainers.properties"
        echo ">:_ $cmd"
        eval $cmd

        cmd="exit"
    fi
    if [ "$1" = "os-upgrade" ]; then
        echo ">:_ sudo apt update"
        sudo apt update

        echo ">:_ sudo apt upgrade -y"
        sudo apt upgrade -y

        echo ">:_ sudo apt autoremove -y"
        sudo apt autoremove -y

        echo ">:_ sudo apt clean"
        sudo apt clean

        cmd="exit"
    fi
    if [ "$1" = "genpwd" ] ||
        [ "$1" = "genpwd-short" ]; then
        echo ">:_ openssl rand -base64 36 | tr -d '\n' && echo"
        openssl rand -base64 36 | tr -d '\n' && echo
        cmd="exit"
    fi
    if [ "$1" = "genpwd-strong" ]; then
        echo ">:_ openssl rand -base64 60 | tr -d '\n' && echo"
        openssl rand -base64 60 | tr -d '\n' && echo
        cmd="exit"
    fi
    if [ "$1" = "fix-file-ownerships" ]; then
        echo ">_: sudo chown -R $(id -u):$(id -g) /config"
        sudo chown -R $(id -u):$(id -g) /config

        echo ">_: find /config -type d -print0 | xargs -0 sudo chmod 0755"
        find /config -type d -print0 | xargs -0 sudo chmod 0755

        echo ">_: find /config -type f -print0 | xargs -0 sudo chmod 0644"
        find /config -type f -print0 | xargs -0 sudo chmod 0644

        cmd="exit"
    fi
    if [ "$1" = "fix-file-watchers" ]; then
        echo ">:_ fsInotifyMaxUserWatchesValue=524288"
        fsInotifyMaxUserWatchesValue=524288

        echo ">:_ check_fsInotifyMaxUserWatchesValue=$(cat /proc/sys/fs/inotify/max_user_watches)"
        check_fsInotifyMaxUserWatchesValue=$(cat /proc/sys/fs/inotify/max_user_watches)

        if [ $check_fsInotifyMaxUserWatchesValue -lt $fsInotifyMaxUserWatchesValue ]; then
            echo ">:_ fs.inotify.max_user_watches=$fsInotifyMaxUserWatchesValue | sudo tee -a /etc/sysctl.conf"
            echo fs.inotify.max_user_watches=$fsInotifyMaxUserWatchesValue | sudo tee -a /etc/sysctl.conf

            echo ">:_ sudo sysctl -p"
            sudo sysctl -p
        fi
        cmd="exit"
    fi
    if [ "$1" = "post-install" ]; then
        echo ">:_ me=$(echo $(whoami))"
        ldtMe=$(echo $(whoami))

        echo ">:_ sudo apt update"
        sudo apt update

        echo ">:_ sudo apt upgrade -y"
        sudo apt upgrade -y

        echo ">:_ sudo apt install -y Development Tools"
        sudo apt install -y build-essential curl git git-flow htop mc nano net-tools

        if [ "$(command -v docker)" = "" ] && [ ! "$LDT_VSCODE__DOCKER_ENGINE_VERSION" = "" ]; then
            echo ">:_ sudo apt install -y Docker Engine, version: $LDT_VSCODE__DOCKER_ENGINE_VERSION"
            curl -fsSL https://get.docker.com | /bin/sh

            echo ">:_ sudo adduser $ldtMe docker"
            sudo adduser $ldtMe docker

            echo ">:_ check: docker --version"
            docker --version
            docker compose version
        fi

        if [ "$(command -v java)" = "" ] && [ ! "$LDT_VSCODE__JAVA_VERSION" = "" ]; then
            echo ">:_ sudo apt install -y Java OpenJDK, version: $LDT_VSCODE__JAVA_VERSION"
            sudo apt install -y openjdk-$LDT_VSCODE__JAVA_VERSION-jdk

            echo ">:_ check: java --version"
            java --version
        fi

        if [ "$(command -v node)" = "" ] && [ ! "$LDT_VSCODE__NODEJS_VERSION" = "" ]; then
            echo ">:_ sudo apt install -y ca-certificates gnupg"
            sudo apt install -y ca-certificates gnupg

            echo ">:_ sudo mkdir -p /etc/apt/keyrings"
            sudo mkdir -p /etc/apt/keyrings

            echo ">:_ curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key"
            curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

            echo ">:_ deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$LDT_VSCODE__NODEJS_VERSION.x nodistro main"
            echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$LDT_VSCODE__NODEJS_VERSION.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

            echo ">:_ sudo apt update"
            sudo apt update

            echo ">:_ sudo apt install -y Node.JS, version: $LDT_VSCODE__NODEJS_VERSION"
            sudo apt install -y nodejs

            echo ">:_ check: nodejs --version"
            node --version
            npm --version
        fi

        if [ "$(command -v openvpn)" = "" ] && [ ! "$LDT_VSCODE__OPENVPN_VERSION" = "" ]; then
            echo ">:_ sudo apt install -y OpenVPN, version: $LDT_VSCODE__OPENVPN_VERSION"
            sudo apt install -y openvpn

            echo ">:_ check: openvpn --version"
            openvpn --version
        fi

        echo ">:_ sudo apt autoremove -y"
        sudo apt autoremove -y

        echo ">:_ sudo apt clean"
        sudo apt clean

        cmd="exit"
    fi
}
httpserver() {
    if [ "$LDT_DOCKER__CONTAINER_PORT" = "" ]; then LDT_DOCKER__CONTAINER_PORT=8080; fi

    if [ "$1" = "cache-clear" ] ||
        [ "$1" = "install" ] ||
        [ "$1" = "update" ] ||
        [ "$1" = "run" ] ||
        [ "$1" = "build" ] ||
        [ "$1" = "lint" ] ||
        [ "$1" = "test" ] ||
        [ "$1" = "dist" ] ||
        [ "$1" = "dockerize" ]; then
        npm $*
    fi
    if [ "$1" = "start" ] || [ "$1" = "start:" ]; then
        shift
        dockerPublish="-p $LDT_DOCKER__CONTAINER_PORT:8080"
        cmd="npm run start -- -a 0.0.0.0 -p 8080 $*"
        npm "start:httpserver"
    fi
}
make() {
    if [ "$dockerImage" = "" ] && [ ! "$LDT_DOCKER__CONTIANER_IMAGE" = "" ]; then
        dockerImage=$LDT_DOCKER__CONTIANER_IMAGE
    fi
    if [ "$dockerImage" = "" ] && [ ! "$DOCKER_IMAGE_MAKE" = "" ]; then
        dockerImage=$DOCKER_IMAGE_MAKE
    fi
    if [ "$dockerImage" = "" ]; then
        dockerImage=alpine/make:latest
    fi
    dockerEngine="docker run -it --rm"
    dockerContext=""
    if [ ! "$LDT_DOCKER__CONTAINER_NAME" = "" ]; then
        dockerContext="$dockerContext --name $LDT_DOCKER__CONTAINER_NAME"
    fi
    if [ ! "$LDT_DOCKER__CONTAINER_USER" = "" ]; then
        dockerContext="$dockerContext -u $LDT_DOCKER__CONTAINER_USER"
    else
        dockerContext="$dockerContext -u $(id -u):$(id -g)"
    fi
    dockerContext="$dockerContext -v $PWD:/usr/src"
    dockerContext="$dockerContext -v /etc/group:/etc/group"
    dockerContext="$dockerContext -v /etc/passwd:/etc/passwd"
    if [ ! "$LDT_DOCKER__CONTAINER_VOLUME" = "" ]; then
        IFS=',' read -ra LDT_DOCKER__CONTAINER_VOLUME <<<"$LDT_DOCKER__CONTAINER_VOLUME"
        for i in "${LDT_DOCKER__CONTAINER_VOLUME[@]}"; do
            dockerContext="$dockerContext -v $i"
        done
    fi
    if [ ! "$LDT_DOCKER__CONTIANER_ENV" = "" ]; then
        IFS=',' read -ra LDT_DOCKER__CONTIANER_ENV <<<"$LDT_DOCKER__CONTIANER_ENV"
        for i in "${LDT_DOCKER__CONTIANER_ENV[@]}"; do
            dockerContext="$dockerContext -e $i"
        done
    fi
    if [ "$1" = "start" ]; then
        shift
        if [ "$1" = "docker-compose" ]; then
            dockerImage=$DOCKER_IMAGE_LDW_DOCKER_COMPOSE_COMPILER
            if [ "$dockerImage" = "" ]; then dockerImage=lildworks/docker-compose-compiler:latest; fi
        fi
        if [ "$1" = "terminal-app" ]; then
            dockerImage=$DOCKER_IMAGE_LDW_TERMINAL_APP_COMPILER
            if [ "$dockerImage" = "" ]; then dockerImage=lildworks/terminal-app-compiler:latest; fi
        fi
        if [ "$dockerImage" = "" ]; then dockerImage=alpine/make:latest; fi

        shift
        cmd="make $*"
    fi
    if [ "$1" = "build" ]; then
        shift
        if [ "$1" = "docker-compose" ]; then
            dockerImage=$DOCKER_IMAGE_LDW_DOCKER_COMPOSE_COMPILER
            if [ "$dockerImage" = "" ]; then dockerImage=lildworks/docker-compose-compiler:latest; fi
        fi
        if [ "$1" = "terminal-app" ]; then
            dockerImage=$DOCKER_IMAGE_LDW_TERMINAL_APP_COMPILER
            if [ "$dockerImage" = "" ]; then dockerImage=lildworks/terminal-app-compiler:latest; fi
        fi
        if [ "$dockerImage" = "" ]; then dockerImage=alpine/make:latest; fi

        shift
        cmd="make clean build $*"
    fi
    if [ "$1" = "changelog" ]; then
        dockerImage=$DOCKER_IMAGE_LDW_GIT_CHANGELOG_GENERATOR
        if [ "$dockerImage" = "" ]; then dockerImage=lildworks/git-changelog-generator:latest; fi
        dockerContext="$dockerContext -w /app"

        cmd="make changelog LDW__GIT_CHANGELOG_GENERATOR__WORKING_DIR=/usr/src LDW__GIT_CHANGELOG_GENERATOR__OUTPUT=/usr/src"
    fi
    if [ "$1" = "dockerize" ]; then
        dockerContext="$dockerContext -w /usr/src"
        projectName=$(docker run -i --rm $dockerContext alpine/make:latest make printProjectName)
        projectVersion=$(docker run -i --rm $dockerContext alpine/make:latest make printProjectVersion)
        projectCommitId=$(docker run -i --rm $dockerContext alpine/git:latest rev-parse --short HEAD)
        shift
        dockerize $*
        cmd="exit"
    fi
}
dockerize() {
    if [ "$DOCKER_REGISTRY__PRIVATE" = "" ] && [ ! "$LDT_DOCKER__REGISTRY_PRIVATE" = "" ]; then
        DOCKER_REGISTRY__PRIVATE=true
    fi
    if [ "$DOCKER_USERNAME" = "" ] && [ ! "$LDT_DOCKER__USERNAME" = "" ]; then
        DOCKER_USERNAME=$LDT_DOCKER__USERNAME
    fi
    if [ "$DOCKER_ACCESS_TOKEN" = "" ] && [ ! "$LDT_DOCKER__ACCESS_TOKEN" = "" ]; then
        DOCKER_ACCESS_TOKEN=$LDT_DOCKER__ACCESS_TOKEN
    fi
    if [ "$DOCKER_REGISTRY" = "" ] && [ ! "$LDT_DOCKER__REGISTRY" = "" ]; then
        DOCKER_REGISTRY=$LDT_DOCKER__REGISTRY
    fi
    if [ "$DOCKER_REPOSITORY" = "" ] && [ ! "$LDT_DOCKER__REPOSITORY" = "" ]; then
        DOCKER_REPOSITORY=$LDT_DOCKER__REPOSITORY
    fi
    if [ ! "$DOCKER_REPOSITORY_PATTERN_IMAGE_COMMIT" = "" ]; then
        imageCommit=$(eval echo $DOCKER_REPOSITORY_PATTERN_IMAGE_COMMIT)
    else
        if [ "$DOCKER_REGISTRY" = "" ]; then
            if [ "$DOCKER_REGISTRY__PRIVATE" = "true" ]; then
                imageCommit=$DOCKER_REPOSITORY:${projectName}-${projectVersion}_${projectCommitId}
            else
                imageCommit=$DOCKER_REPOSITORY/${projectName}:${projectVersion}_${projectCommitId}
            fi
        else
            if [ "$DOCKER_REGISTRY__PRIVATE" = "true" ]; then
                imageCommit=$DOCKER_REGISTRY/$DOCKER_REPOSITORY:${projectName}-${projectVersion}_${projectCommitId}
            else
                imageCommit=$DOCKER_REGISTRY/$DOCKER_REPOSITORY/${projectName}:${projectVersion}_${projectCommitId}
            fi
        fi
    fi
    if [ ! "$DOCKER_REPOSITORY_PATTERN_IMAGE_VERSION" = "" ]; then
        imageVersion=$(eval echo $DOCKER_REPOSITORY_PATTERN_IMAGE_VERSION)
    else
        if [ "$DOCKER_REGISTRY" = "" ]; then
            if [ "$DOCKER_REGISTRY__PRIVATE" = "true" ]; then
                imageVersion=$DOCKER_REPOSITORY:${projectName}-${projectVersion}
            else
                imageVersion=$DOCKER_REPOSITORY/${projectName}:${projectVersion}
            fi
        else
            if [ "$DOCKER_REGISTRY__PRIVATE" = "true" ]; then
                imageVersion=$DOCKER_REGISTRY/$DOCKER_REPOSITORY:${projectName}-${projectVersion}
            else
                imageVersion=$DOCKER_REGISTRY/$DOCKER_REPOSITORY/${projectName}:${projectVersion}
            fi
        fi
    fi
    if [ ! "$DOCKER_REPOSITORY_PATTERN_IMAGE_LATEST" = "" ]; then
        imageLatest=$(eval echo $DOCKER_REPOSITORY_PATTERN_IMAGE_LATEST)
    else
        if [ "$DOCKER_REGISTRY" = "" ]; then
            if [ "$DOCKER_REGISTRY__PRIVATE" = "true" ]; then
                imageLatest=$DOCKER_REPOSITORY:${projectName}-latest
            else
                imageLatest=$DOCKER_REPOSITORY/${projectName}:latest
            fi
        else
            if [ "$DOCKER_REGISTRY__PRIVATE" = "true" ]; then
                imageLatest=$DOCKER_REGISTRY/$DOCKER_REPOSITORY:${projectName}-latest
            else
                imageLatest=$DOCKER_REGISTRY/$DOCKER_REPOSITORY/${projectName}:latest
            fi
        fi
    fi
    echo $DOCKER_ACCESS_TOKEN | docker login $DOCKER_REGISTRY --username $DOCKER_USERNAME --password-stdin
    if [ $? = 0 ]; then
        if [ ! "$imageCommit" = "-" ] && [ ! "$imageVersion" = "-" ] && [ ! "$imageLatest" = "-" ]; then
            echo ">:_ dockerize='docker buildx build $* --push --tag $imageCommit --tag $imageVersion --tag $imageLatest .'"
            docker buildx build $* --push --tag $imageCommit --tag $imageVersion --tag $imageLatest .
        fi
        if [ "$imageCommit" = "-" ] && [ ! "$imageVersion" = "-" ] && [ ! "$imageLatest" = "-" ]; then
            echo ">:_ dockerize='docker buildx build $* --push --tag $imageVersion --tag $imageLatest .'"
            docker buildx build $* --push --tag $imageVersion --tag $imageLatest .
        fi
        if [ "$imageCommit" = "-" ] && [ "$imageVersion" = "-" ] && [ ! "$imageLatest" = "-" ]; then
            echo ">:_ dockerize='docker buildx build $* --push --tag $imageLatest .'"
            docker buildx build $* --push --tag $imageLatest .
        fi
        docker logout
    fi
}
mysql() {
    if [ "$LDT_DOCKER__CONTAINER_NETWORK" = "" ]; then LDT_DOCKER__CONTAINER_NETWORK=mysql; fi
    checkNetwork=$(docker network ls | grep $LDT_DOCKER__CONTAINER_NETWORK)
    if [ "$checkNetwork" = "" ]; then
        docker network create $LDT_DOCKER__CONTAINER_NETWORK
    fi
    if [ "$dockerImage" = "" ] && [ ! "$LDT_DOCKER__CONTIANER_IMAGE" = "" ]; then
        dockerImage=$LDT_DOCKER__CONTIANER_IMAGE
    fi
    if [ "$dockerImage" = "" ] && [ ! "$DOCKER_IMAGE_MYSQL" = "" ]; then
        dockerImage=$DOCKER_IMAGE_MYSQL
    fi
    if [ "$dockerImage" = "" ]; then
        dockerImage=mysql:latest
    fi
    dockerEngine="docker run -it --rm"
    dockerContext=""
    if [ ! "$LDT_DOCKER__CONTAINER_NAME" = "" ]; then
        dockerContext="$dockerContext --name $LDT_DOCKER__CONTAINER_NAME"
    fi
    if [ ! "$LDT_DOCKER__CONTAINER_NETWORK" = "" ]; then
        dockerContext="$dockerContext --network $LDT_DOCKER__CONTAINER_NETWORK"
    fi
    if [ ! "$LDT_DOCKER__CONTAINER_VOLUME" = "" ]; then
        IFS=',' read -ra LDT_DOCKER__CONTAINER_VOLUME <<<"$LDT_DOCKER__CONTAINER_VOLUME"
        for i in "${LDT_DOCKER__CONTAINER_VOLUME[@]}"; do
            dockerContext="$dockerContext -v $i"
        done
    else
        dockerContext="$dockerContext -v $PWD/mysql:/var/lib/mysql"
    fi
    dockerContext="$dockerContext -e MYSQL_ROOT_USER=mysql"
    dockerContext="$dockerContext -e MYSQL_ROOT_PASSWORD=mysql"

    if [ "$1" = "start" ]; then
        dockerPublish="-p 3306:3306 -p 33060:33060"
        cmd="mysqld --default-authentication-plugin=mysql_native_password"
    fi
}
nginx() {
    if [ "$LDT_DOCKER__CONTAINER_PORT" = "" ]; then LDT_DOCKER__CONTAINER_PORT=8080; fi

    if [ "$dockerImage" = "" ] && [ ! "$LDT_DOCKER__CONTIANER_IMAGE" = "" ]; then
        dockerImage=$LDT_DOCKER__CONTIANER_IMAGE
    fi
    if [ "$dockerImage" = "" ] && [ ! "$DOCKER_IMAGE_NGINX" = "" ]; then
        dockerImage=$DOCKER_IMAGE_NGINX
    fi
    if [ "$dockerImage" = "" ]; then
        dockerImage=nginx:stable
    fi
    dockerEngine="docker run -it --rm"
    dockerContext=""
    if [ ! "$LDT_DOCKER__CONTAINER_NAME" = "" ]; then
        dockerContext="$dockerContext --name $LDT_DOCKER__CONTAINER_NAME"
    fi
    dockerContext="$dockerContext -v $PWD/dist/html:/usr/share/nginx/html"
    if [ -f "$PWD/dist/conf/nginx.conf" ]; then
        dockerContext="$dockerContext -v $PWD/dist/conf/nginx.conf:/etc/nginx/nginx.conf"
    fi
    if [ ! "$LDT_DOCKER__CONTAINER_VOLUME" = "" ]; then
        IFS=',' read -ra LDT_DOCKER__CONTAINER_VOLUME <<<"$LDT_DOCKER__CONTAINER_VOLUME"
        for i in "${LDT_DOCKER__CONTAINER_VOLUME[@]}"; do
            dockerContext="$dockerContext -v $i"
        done
    fi
    if [ "$2" = "--php-fpm" ]; then
        dockerContext="$dockerContext --network php-fpm"
    fi
    dockerContext="$dockerContext -w /usr/share/nginx/html"

    if [ "$1" = "start" ]; then
        dockerPublish="-p $LDT_DOCKER__CONTAINER_PORT:80"
        cmd="start:nginx"
    fi
}
rabbitmq() {
    if [ "$dockerImage" = "" ] && [ ! "$LDT_DOCKER__CONTIANER_IMAGE" = "" ]; then
        dockerImage=$LDT_DOCKER__CONTIANER_IMAGE
    fi
    if [ "$dockerImage" = "" ] && [ ! "$DOCKER_IMAGE_RABBITMQ" = "" ]; then
        dockerImage=$DOCKER_IMAGE_RABBITMQ
    fi
    if [ "$dockerImage" = "" ]; then
        dockerImage=rabbitmq:stable
    fi
    dockerEngine="docker run -it --rm"
    dockerContext=""
    if [ ! "$LDT_DOCKER__CONTAINER_NAME" = "" ]; then
        dockerContext="$dockerContext --name $LDT_DOCKER__CONTAINER_NAME"
    fi
    if [ ! "$LDT_DOCKER__CONTAINER_NETWORK" = "" ]; then
        dockerContext="$dockerContext --network $LDT_DOCKER__CONTAINER_NETWORK"
    fi
    if [ ! "$LDT_DOCKER__CONTAINER_VOLUME" = "" ]; then
        IFS=',' read -ra LDT_DOCKER__CONTAINER_VOLUME <<<"$LDT_DOCKER__CONTAINER_VOLUME"
        for i in "${LDT_DOCKER__CONTAINER_VOLUME[@]}"; do
            dockerContext="$dockerContext -v $i"
        done
    else
        dockerContext="$dockerContext -v $PWD/rabbitmq:/var/lib/rabbitmq"
    fi
    dockerContext="$dockerContext -e RABBITMQ_DEFAULT_USER=rabbitmq"
    dockerContext="$dockerContext -e RABBITMQ_DEFAULT_PASS=rabbitmq"
    dockerContext="$dockerContext -e RABBITMQ_DEFAULT_VHOST=/"

    if [ "$1" = "start" ]; then
        dockerPublish="-p 5672:5672 -p 15672:15672"
        cmd=" "
    fi
}
phpfpm() {
    if [ "$LDT_DOCKER__CONTAINER_NETWORK" = "" ]; then LDT_DOCKER__CONTAINER_NETWORK=php-fpm; fi
    checkNetwork=$(docker network ls | grep $LDT_DOCKER__CONTAINER_NETWORK)
    if [ "$checkNetwork" = "" ]; then
        docker network create $LDT_DOCKER__CONTAINER_NETWORK
    fi
    if [ "$LDT_DOCKER__CONTAINER_PORT" = "" ]; then LDT_DOCKER__CONTAINER_PORT=9000; fi

    if [ "$dockerImage" = "" ] && [ ! "$LDT_DOCKER__CONTIANER_IMAGE" = "" ]; then
        dockerImage=$LDT_DOCKER__CONTIANER_IMAGE
    fi
    if [ "$dockerImage" = "" ] && [ ! "$DOCKER_IMAGE_PHP_FPM" = "" ]; then
        dockerImage=$DOCKER_IMAGE_PHP_FPM
    fi
    if [ "$dockerImage" = "" ]; then
        dockerImage=php:8.2-fpm
    fi
    dockerEngine="docker run -it --rm"
    dockerContext=""
    if [ ! "$LDT_DOCKER__CONTAINER_NAME" = "" ]; then
        dockerContext="$dockerContext --name $LDT_DOCKER__CONTAINER_NAME"
    fi
    dockerContext="$dockerContext --name php-fpm"
    dockerContext="$dockerContext --network php-fpm"
    dockerContext="$dockerContext -v $PWD/dist/html:/usr/share/nginx/html"
    if [ ! "$LDT_DOCKER__CONTAINER_VOLUME" = "" ]; then
        IFS=',' read -ra LDT_DOCKER__CONTAINER_VOLUME <<<"$LDT_DOCKER__CONTAINER_VOLUME"
        for i in "${LDT_DOCKER__CONTAINER_VOLUME[@]}"; do
            dockerContext="$dockerContext -v $i"
        done
    fi
    dockerContext="$dockerContext -w /usr/share/nginx/html"

    if [ "$1" = "clear" ]; then
        checkNetwork=$(docker network ls | grep php-fpm)
        if [ ! "$checkNetwork" = "" ]; then
            docker network rm php-fpm
        fi
    fi
    if [ "$1" = "start" ]; then
        dockerPublish="-p $LDT_DOCKER__CONTAINER_PORT:9000"
        cmd="start:php-fpm"
    fi
}
adminjs() {
    if [ "$LDT_DOCKER__CONTAINER_PORT" = "" ]; then LDT_DOCKER__CONTAINER_PORT=3300; fi

    if [ "$1" = "cache-clear" ] ||
        [ "$1" = "install" ] ||
        [ "$1" = "update" ] ||
        [ "$1" = "run" ] ||
        [ "$1" = "build" ] ||
        [ "$1" = "lint" ] ||
        [ "$1" = "test" ] ||
        [ "$1" = "dist" ] ||
        [ "$1" = "dockerize" ]; then
        npm $*
    fi
    if [ "$1" = "start" ]; then
        shift
        dockerPublish="-p $LDT_DOCKER__CONTAINER_PORT:3000"
        cmd="npm run start -- $*"
        npm start:adminjs
    fi
}
php() {
    if [ "$dockerImage" = "" ] && [ ! "$LDT_DOCKER__CONTIANER_IMAGE" = "" ]; then
        dockerImage=$LDT_DOCKER__CONTIANER_IMAGE
    fi
    if [ "$dockerImage" = "" ] && [ ! "$DOCKER_IMAGE_PHP" = "" ]; then
        dockerImage=$DOCKER_IMAGE_PHP
    fi
    if [ "$dockerImage" = "" ]; then
        dockerImage=php:8.2
    fi
    dockerEngine="docker run -it --rm"
    dockerContext=""
    if [ ! "$LDT_DOCKER__CONTAINER_NAME" = "" ]; then
        dockerContext="$dockerContext --name $LDT_DOCKER__CONTAINER_NAME"
    fi
    if [ ! "$LDT_DOCKER__CONTAINER_USER" = "" ]; then
        dockerContext="$dockerContext -u $LDT_DOCKER__CONTAINER_USER"
    else
        dockerContext="$dockerContext -u $(id -u):$(id -g)"
    fi
    dockerContext="$dockerContext -v $PWD:/usr/src"
    if [ ! "$LDT_DOCKER__CONTAINER_VOLUME" = "" ]; then
        IFS=',' read -ra LDT_DOCKER__CONTAINER_VOLUME <<<"$LDT_DOCKER__CONTAINER_VOLUME"
        for i in "${LDT_DOCKER__CONTAINER_VOLUME[@]}"; do
            dockerContext="$dockerContext -v $i"
        done
    fi
    dockerContext="$dockerContext -w /usr/src"

    if [ "$1" = "run" ]; then
        shift
        if [ "$*" = "" ]; then
            cmd="/bin/bash"
        else
            cmd="/bin/bash -c \"$*\""
        fi
    fi
    if [ "$1" = "exec" ]; then
        shift
        cmd="php $*"
    fi
}
sonar() {
    if [ "$dockerImage" = "" ] && [ ! "$LDT_DOCKER__CONTIANER_IMAGE" = "" ]; then
        dockerImage=$LDT_DOCKER__CONTIANER_IMAGE
    fi
    if [ "$dockerImage" = "" ] && [ ! "$DOCKER_IMAGE_GRADLE" = "" ]; then
        dockerImage=$DOCKER_IMAGE_GRADLE
    fi
    if [ "$dockerImage" = "" ]; then
        dockerImage=sonarsource/sonar-scanner-cli:latest
    fi

    dockerEngine="docker run -it --rm"
    dockerContext=""
    if [ ! "$LDT_DOCKER__CONTAINER_NAME" = "" ]; then
        dockerContext="$dockerContext --name $LDT_DOCKER__CONTAINER_NAME"
    fi
    if [ ! "$LDT_DOCKER__CONTAINER_NETWORK" = "" ]; then
        dockerContext="$dockerContext --network $LDT_DOCKER__CONTAINER_NETWORK"
    else
        dockerContext="$dockerContext --network host"
    fi
    if [ ! "$LDT_DOCKER__CONTAINER_USER" = "" ]; then
        dockerContext="$dockerContext -u $LDT_DOCKER__CONTAINER_USER"
    else
        dockerContext="$dockerContext -u $(id -u):$(id -g)"
    fi
    dockerContext="$dockerContext -v $PWD:/usr/src"
    dockerContext="$dockerContext -v /etc/group:/etc/group"
    dockerContext="$dockerContext -v /etc/passwd:/etc/passwd"
    if [ ! "$LDT_DOCKER__CONTAINER_VOLUME" = "" ]; then
        IFS=',' read -ra LDT_DOCKER__CONTAINER_VOLUME <<<"$LDT_DOCKER__CONTAINER_VOLUME"
        for i in "${LDT_DOCKER__CONTAINER_VOLUME[@]}"; do
            dockerContext="$dockerContext -v $i"
        done
    fi
    dockerContext="$dockerContext -w /usr/src"
    dockerContext="$dockerContext -e SONAR_USER_HOME=/usr/src/.sonar"
    dockerContext="$dockerContext -e SONAR_PROJECT_KEY=$SONAR_PROJECT_KEY"
    dockerContext="$dockerContext -e SONAR_HOST_URL=$SONAR_HOST_URL"
    dockerContext="$dockerContext -e SONAR_TOKEN=$SONAR_TOKEN"
    dockerContext="$dockerContext -e GIT_DEPTH=\"0\""
    if [ ! "$LDT_DOCKER__CONTIANER_ENV" = "" ]; then
        IFS=',' read -ra LDT_DOCKER__CONTIANER_ENV <<<"$LDT_DOCKER__CONTIANER_ENV"
        for i in "${LDT_DOCKER__CONTIANER_ENV[@]}"; do
            dockerContext="$dockerContext -e $i"
        done
    fi

    if [ "$1" = "scan" ]; then
        cmd="/bin/bash -c \"echo \\\"sonar.projectKey=\\\${SONAR_PROJECT_KEY}\\\" >sonar-project.properties"
        cmd="$cmd && echo \\\"sonar.host.url=\\\${SONAR_HOST_URL}\\\" >>sonar-project.properties"
        cmd="$cmd && echo \\\"sonar.qualitygate.wait=true\\\" >>sonar-project.properties"
        cmd="$cmd && echo \\\"sonar.sourceEncoding=UTF-8\\\" >>sonar-project.properties"
        cmd="$cmd && sonar-scanner ; rm -rf .sonar/ .scannerwork/ sonar-project.properties\""
    fi
}
main $*
