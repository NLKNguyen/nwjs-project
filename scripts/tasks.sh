#!/bin/sh

# Default values if providing empty
NWJS_ARCHS="win-x64 win-ia32 linux-x64 linux-ia32 osx-x64"
NWJS_SDK_ARCHS="win-x64 win-ia32 linux-x64 linux-ia32 osx-x64"
PACKAGE_ARCHS="win-x64 win-ia32 linux-x64 linux-ia32 osx-x64"
PACKAGE_NAME="app"

usage ()
{
    echo "if this was a real script you would see something useful here"
    echo ""
    echo "./simple_args_parsing.sh"
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
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`

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
        if [[ -d "/opt/nwjs/$arch" ]]; then
            echo -n "Copy NW.js runtime for $arch to project directory... "

            mkdir -p /project/nwjs
            rsync -a /opt/nwjs/${arch} /project/nwjs/
              
            [ "$?" -ne 0 ] && echo "ERROR: can't copy nwjs/$arch" && exit 1

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
        if [[ -d "/opt/nwjs-sdk/$arch" ]]; then
            echo -n "Copy NW.js SDK runtime for $arch to project directory... "

            mkdir -p /project/nwjs-sdk
            rsync -a /opt/nwjs-sdk/${arch} /project/nwjs-sdk/

            [ "$?" -ne 0 ] && echo "ERROR: can't copy nwjs-sdk/$arch" && exit 1

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
    echo "sh /opt/package.sh \"$PACKAGE_NAME\" \"$PACKAGE_ARCHS\""
    sh /opt/package.sh "$PACKAGE_NAME" "$PACKAGE_ARCHS"
    
fi

# echo "ENVIRONMENT is $ENVIRONMENT";
# echo "DB_PATH is $DB_PATH";

# echo '--init'

# echo -n 'Getting NW.js runtime to the directory ./nwjs/ .... '
# rsync -a /opt/nwjs/ /project/nwjs
# [ "$?" -ne 0 ] && echo failed && exit 1
# echo done
# case "$arch" in
#     *win-x64*)
#         rsync -a /opt/nwjs/win-x64 /project/nwjs/win-x64
#         [ "$?" -ne 0 ] && echo "ERROR: can't copy nwjs/$arch" && exit 1
#         ;;
# esac
# echo "arch=$arch"
# if [[ "win-x64" == *win-x64* ]]
# then
#     echo "in"
#     rsync -a /opt/nwjs/${arch} /project/nwjs/${arch}
#     [ "$?" -ne 0 ] && echo "ERROR: can't copy nwjs/$arch" && exit 1
# else
#     echo "ERROR: unknown architecture $arch for --nwjs"
#     echo "All possible architectures to include: --nwjs=\"$valid_archs\" "
#     exit 1
# fi