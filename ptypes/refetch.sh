#!/bin/bash -e
#
# This script fetches the latest version of the well-known-type .protos.

PKG=github.com/golang/protobuf/ptypes
UPSTREAM=https://github.com/google/protobuf
UPSTREAM_SUBDIR=src/google/protobuf
PROTO_FILES=(any duration empty struct timestamp wrappers)

set -e

tmpdir=$(mktemp -d -t regen-wkt.XXXXXX)
trap 'rm -rf $tmpdir' EXIT

echo "Cloning $UPSTREAM"
git clone -q --depth=1 $UPSTREAM $tmpdir
for file in ${PROTO_FILES[@]}; do
  echo 1>&2 "* $file"
  cp $tmpdir/src/google/protobuf/$file.proto $file
done
