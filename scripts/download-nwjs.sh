#!/bin/sh
set -e

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

            wget "${link_url}"
            
            architecture_dir=$(echo "$ending" | cut -f 1 -d '.') # arch ending without extension
            extracted_dir=''

            case "$file_name" in
                  *.zip)
                        unzip "${file_name}"
                        extracted_dir=$(basename "$file_name" .zip)
                        ;;
                  *.tar.gz)
                        tar -xvzf "${file_name}"
                        extracted_dir=$(basename "$file_name" .tar.gz)
                        ;;
                  *)
                        echo "$file_name"
                        echo "Unexpected file extension for decompression"
                        exit 1
                        ;;

            esac
            
             mv "${extracted_dir}" "../${architecture_dir}"
             rm -rf "${file_name}"

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