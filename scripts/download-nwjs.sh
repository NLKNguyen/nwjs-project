#!/bin/sh


NWJS_VERSION="${NWJS_VERSION:=0.16.0}"

obtain () {
      link_prefix=$1
      file_prefix=$2
      arch_endings=$3

      mkdir downloads
      cd downloads

      for ending in $arch_endings
      do
            link_url="${link_prefix}${file_prefix}${ending}"
            file_name="${file_prefix}${ending}"
            
            echo "Download $link_url"

            wget ${link_url}
            [ "$?" -ne 0 ] && echo "ERROR: can't download $link_url" && exit 1
            
            architecture_dir=$(echo $ending | cut -f 1 -d '.') # arch ending without extension
            extracted_dir=''

            if [[ "$file_name" == *.zip ]]; then
                  unzip ${file_name}
                  extracted_dir=$(basename $file_name .zip)
                 
            elif [[ "$file_name" == *.tar.gz ]]; then
                  tar -xvzf ${file_name}
                  extracted_dir=$(basename $file_name .tar.gz)
            
            else
                  echo "$file_name"
                  echo "Unexpected file extension for decompression"
                  exit 1
            fi
            
             mv ${extracted_dir} ../${architecture_dir}
             rm -rf ${file_name}

      done

      cd ..
      rm -rf downloads
}

mkdir -p /opt/nwjs
cd /opt/nwjs
obtain "http://dl.nwjs.io/v${NWJS_VERSION}/" "nwjs-v${NWJS_VERSION}-"  "win-x64.zip \
                                                                        win-ia32.zip \
                                                                        linux-x64.tar.gz \
                                                                        linux-ia32.tar.gz \
                                                                        osx-x64.zip"

mkdir -p /opt/nwjs-sdk
cd /opt/nwjs-sdk
obtain "http://dl.nwjs.io/v${NWJS_VERSION}/" "nwjs-sdk-v${NWJS_VERSION}-"  "win-x64.zip \
                                                                            win-ia32.zip \
                                                                            linux-x64.tar.gz \
                                                                            linux-ia32.tar.gz \
                                                                            osx-x64.zip"


# obtain "http://dl.nwjs.io/v${NWJS_VERSION}/" "nwjs-v${NWJS_VERSION}-"   "win-x64.zip \
#                                                                         linux-x64.tar.gz"
# ls *

# if_error_then_echo () {
#       if [ $? -ne 0 ]; then
#             echo "==> $1"
#             exit 1
#       fi
# }

#####################################
      ## For convenience: place the version number as the name of a file in the directory
      # touch ${dest_dir}/v${NWJS_VERSION}
#####################################
# obtain_nwjs_sdk () {
#       cd /tmp/nwjs-downloads

#       ## Get win64 version
#       wget http://dl.nwjs.io/v${NWJS_VERSION}/nwjs-sdk-v${NWJS_VERSION}-win-x64.zip \
#             && unzip nwjs-sdk-v${NWJS_VERSION}-win-x64.zip

#       if_error_then_echo "Error when obtaining NW.js SDK for win64"

#       # Create NW.js SDK directory
#       mkdir -p /opt/nwjs-sdk/
#       ## For convenience: place the version number as the name of a file in the directory
#       touch /opt/nwjs-sdk/v${NWJS_VERSION}

#       mv nwjs-sdk-v${NWJS_VERSION}-win-x64 /opt/nwjs-sdk/win64

#       rm -rf /tmp/nwjs-downloads/*
# }

# obtain_nwjs_sdk
