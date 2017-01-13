#!/bin/sh
set -e

MOUNTED_DIR="/mnt"

# Default values if providing empty
NWJS_ARCHS="win-x64 win-ia32 linux-x64 linux-ia32 osx-x64"
NWJS_SDK_ARCHS="win-x64 win-ia32 linux-x64 linux-ia32 osx-x64"
PACKAGE_ARCHS="win-x64 win-ia32 linux-x64 linux-ia32 osx-x64"
PACKAGE_NAME="app"

usage ()
{
    echo "NWJS PROJECT"
    echo ""
    echo "  -h --help"
    echo "  --shell"
    echo "  "
    echo "  --nwjs=\"$NWJS_ARCHS\""
    echo "    Copy NW.js runtime for given architecture(s) to project directory"
    echo "  "
    echo "  --nwjs-sdk=\"$NWJS_SDK_ARCHS\""
    echo "    Copy NW.js SDK runtime for given architecture(s) to project directory"
    echo "  "
    echo "  --package=\"$PACKAGE_ARCHS\""
    echo "  --name=\"$PACKAGE_NAME\""
    echo "  "
}

#######################
# TASK INDICATORS
TASK_PACKAGE=0
TASK_NWJS=0
TASK_NWJS_SDK=0

#######################
# ARGUMENTS PARSER

# Default argument if empty
[ "$1" = "" ] && set -- "--shell"

while [ "$1" != "" ];
do
    PARAM=$(echo "$1" | awk -F= '{print $1}')
    VALUE=$(echo "$1" | awk -F= '{print $2}')

    case $PARAM in
        -h | --help)
            usage
            exit
            ;;

        --shell)
            ash
            exit
            ;;

        --nwjs)
            TASK_NWJS=1
            [ "$VALUE" ] && NWJS_ARCHS=$VALUE
            ;;

        --nwjs-sdk)
            TASK_NWJS_SDK=1
            [ "$VALUE" ] && NWJS_SDK_ARCHS=$VALUE
            ;;

        --package)
            TASK_PACKAGE=1
            [ "$VALUE" ] && PACKAGE_ARCHS=$VALUE
            ;;
        --name)
            [ "$VALUE" ] && PACKAGE_NAME=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

#######################
# TASK: COPY NWJS
if [ $TASK_NWJS -eq 1 ]; then
    for arch in $NWJS_ARCHS
    do
        if [ -d "/opt/nwjs/$arch" ]; then
            printf "Copy NW.js runtime for %s to project directory... " "$arch"

            mkdir -p ${MOUNTED_DIR}/nwjs
            rsync -a "/opt/nwjs/${arch}" ${MOUNTED_DIR}/nwjs/

            echo "done"

            printf "Copy shortcut launcher for %s to project directory... " "$arch"
            case $arch in
                *osx*)
                    rsync -a "/opt/shortcuts/nw.$arch.command" ${MOUNTED_DIR}/
                    chmod +x "${MOUNTED_DIR}/nw.$arch.command"
                    ;;
                *linux*)
                    rsync -a "/opt/shortcuts/nw.$arch.desktop" ${MOUNTED_DIR}/
                    chmod +x "${MOUNTED_DIR}/nw.$arch.desktop"
                    ;;
                *win*)
                    echo "Currently not available for Windows yet"
                    # TODO: Windows shit goes here
                    ;;
            esac
            echo "done"
        else
            echo "ERROR: unknown architecture $arch for --nwjs"
            exit 1
        fi
    done
fi

#######################
# TASK: COPY NWJS SDK
if [ $TASK_NWJS_SDK -eq 1 ]; then
    for arch in $NWJS_SDK_ARCHS
    do
        if [ -d "/opt/nwjs-sdk/$arch" ]; then
            printf "Copy NW.js runtime for %s to project directory... " "$arch"

            mkdir -p ${MOUNTED_DIR}/nwjs-sdk
            rsync -a "/opt/nwjs-sdk/${arch}" ${MOUNTED_DIR}/nwjs-sdk/

            echo "done"
        else
            echo "ERROR: unknown architecture $arch for --nwjs-sdk"
            exit 1
        fi
    done
fi

#######################
# TASK: PACKAGE
if [ $TASK_PACKAGE -eq 1 ]; then
    echo "sh /opt/scripts/package.sh \"$PACKAGE_NAME\" \"$PACKAGE_ARCHS\""
    sh /opt/scripts/package.sh "$PACKAGE_NAME" "$PACKAGE_ARCHS"
fi
