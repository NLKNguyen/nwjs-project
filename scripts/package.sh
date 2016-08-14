#!/bin/sh
echo '--package'

PACKAGE_NAME=$1
PACKAGE_ARCHS=$2

echo "packaging $PACKAGE_NAME for $PACKAGE_ARCHS"

# echo 'packaging: get source from project directory...'
# if [ -e /project/.nwjsignore ]; then
#   rsync -a --exclude-from=/project/.nwjsignore  /project/ /tmp/project
# else
#   rsync -a --exclude 'nwjs' /project/ /tmp/project
# fi

# mkdir -p /tmp/release/

# echo 'packaging: prepare for win64 release...'
# rsync -a /tmp/project/ /tmp/release/win64
# rsync -a /opt/nwjs/win64/ /tmp/release/win64

# mkdir -p /project/release

# echo 'packaging: zip win64 release...'
# cd /tmp/release/win64
# zip -r /project/release/win64.zip .
