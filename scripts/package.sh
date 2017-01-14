#!/bin/sh
set -e

MOUNTED_DIR="/mnt"

echo '--package'

PACKAGE_NAME=$1
PACKAGE_ARCHS=$2
# PACKAGE_VERSION=$3

echo "packaging $PACKAGE_NAME for $PACKAGE_ARCHS"

echo 'packaging: get source from project directory...'
if [ -e ${MOUNTED_DIR}/.nwjsignore ]; then
    echo "Found .nwjsignore => Use for ignoring files from source directory"
    rsync -a --exclude-from=${MOUNTED_DIR}/.nwjsignore  ${MOUNTED_DIR}/ /tmp/src
else
    rsync -a --exclude='nwjs' --exclude='nwjs-sdk' --exclude='release' ${MOUNTED_DIR}/ /tmp/src
fi


cd /tmp/src/
# BUILD
if [ -e ${MOUNTED_DIR}/build-script.sh ]; then
    printf "Found build-script.sh => Executing... "
    sh ${MOUNTED_DIR}/build-script.sh
    echo "done"
fi

echo ""

for arch in $PACKAGE_ARCHS
do

    if [ -d "/opt/nwjs-sdk/$arch" ]; then
        echo "Create package for $arch in release directory... "

        case $arch in
        *osx*)
            mkdir -p "$MOUNTED_DIR/release/$arch/app.nw/"
            echo "Copy project source files... "
            rsync -a "/tmp/src/" "$MOUNTED_DIR/release/$arch/app.nw"

            cd "$MOUNTED_DIR/release/$arch/"

            echo "Copy runtime files for $arch..."
            if [ -e ${MOUNTED_DIR}/.nwjsignore ]; then
                echo "Found .nwjsignore => Use for ignoring files from NW.js runtime directory"
                rsync -a --exclude-from=${MOUNTED_DIR}/.nwjsignore "/opt/nwjs/${arch}/" "$MOUNTED_DIR/release/$arch"
            else
                rsync -a "/opt/nwjs/${arch}/" "$MOUNTED_DIR/release/$arch"
            fi

            mv app.nw nwjs.app/Contents/Resources/
            mv nwjs.app "$PACKAGE_NAME.app"

            printf "Make zip file... "
            cd "$MOUNTED_DIR/release/"
            zip -r "$PACKAGE_NAME-$arch.zip" "$arch/"
            echo "done"
            ;;

        *win*)
            mkdir -p "$MOUNTED_DIR/release/$arch/package.nw/"

            cd "$MOUNTED_DIR/release/$arch/"

            echo "Copy runtime files for $arch..."
            if [ -e ${MOUNTED_DIR}/.nwjsignore ]; then
                echo "Found .nwjsignore => Use for ignoring files from NW.js runtime directory"
                rsync -a --exclude-from=${MOUNTED_DIR}/.nwjsignore "/opt/nwjs/${arch}/" "$MOUNTED_DIR/release/$arch"
            else
                rsync -a "/opt/nwjs/${arch}/" "$MOUNTED_DIR/release/$arch"
            fi

            echo "Copy project source files... "
            rsync -a "/tmp/src/" "$MOUNTED_DIR/release/$arch/package.nw"

            printf "Make zip file... "
            cd "$MOUNTED_DIR/release/"
            zip -r "$PACKAGE_NAME-$arch.zip" "$arch/"
            echo "done"
            ;;

        *linux*)
            mkdir -p "$MOUNTED_DIR/release/$arch/app.nw/"

            cd "$MOUNTED_DIR/release/$arch/"

            echo "Copy runtime files for $arch..."
            if [ -e ${MOUNTED_DIR}/.nwjsignore ]; then
                echo "Found .nwjsignore => Use for ignoring files from NW.js runtime directory"
                rsync -a --exclude-from=${MOUNTED_DIR}/.nwjsignore "/opt/nwjs/${arch}/" "$MOUNTED_DIR/release/$arch"
            else
                rsync -a "/opt/nwjs/${arch}/" "$MOUNTED_DIR/release/$arch"
            fi

            echo "Copy project source files... "
            rsync -a "/tmp/src/" "$MOUNTED_DIR/release/$arch/app.nw"

            cp /opt/shortcuts/nw.$arch.desktop "$PACKAGE_NAME.desktop"
            sed -i "s/Name=.*/Name=$PACKAGE_NAME/g" "$PACKAGE_NAME.desktop"
            sed -i 's|Exec=.*|Exec=sh -c "cd `dirname %k`; ./nw app.nw/"|g' "$PACKAGE_NAME.desktop"
            chmod +x "$PACKAGE_NAME.desktop"

            printf "Make zip file... "
            cd "$MOUNTED_DIR/release/"
            zip -r "$PACKAGE_NAME-$arch.zip" "$arch/"
            echo "done"
            ;;
        esac



        echo "done"
    else
        echo "ERROR: unknown architecture $arch for --package"
        exit 1
    fi
done
# mkdir -p /tmp/release/

# echo 'packaging: prepare for win64 release...'
# rsync -a /tmp/project/ /tmp/release/win64
# rsync -a /opt/nwjs/win64/ /tmp/release/win64

# mkdir -p /project/release

# echo 'packaging: zip win64 release...'
# cd /tmp/release/win64
# zip -r /project/release/win64.zip .
