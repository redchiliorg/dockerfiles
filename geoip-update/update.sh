#!/bin/sh

set -e

assert() { if [ -z "$1" ]; then echo "$2" > /dev/stderr; exit 1; fi }

assert "${GEOIP_EDITION}"       "GEOIP_EDITION variable is required"
assert "${GEOIP_LICENSE_KEY}"   "GEOIP_LICENSE_KEY variable is required"
assert "${GEOIP_OUT_PATH}"      "GEOIP_OUT_PATH variable is required"

BASE=https://download.maxmind.com/app/geoip_download
TMP_DIR=/tmp/geoip-$(date +%Y%m%d%H%M%S)
TMP_FILE=$TMP_DIR/${GEOIP_EDITION}.tar.gz
OUT_FILE=${GEOIP_OUT_PATH}/${GEOIP_EDITION}.tar.gz
URL="$BASE?edition_id=${GEOIP_EDITION}&license_key=${GEOIP_LICENSE_KEY}&suffix=tar.gz"

mkdir -p $TMP_DIR
cd $TMP_DIR
wget -O "$TMP_FILE" "$URL"
tar x -f $TMP_FILE
cp ./**/* ${GEOIP_OUT_PATH}
