#!/bin/bash -e
#
# This script rebuilds the well-known types protocol buffers.

# We need this script for a fairly trivial reason: The source filenames
# should be located under the directory google/protobuf, but the copies
# of the WKT protos in this repo have no such prefix. So we copy them to
# a tempdir with the appropriate path suffix before compilation.

set -e

tmpdir=$(mktemp -d -t regen-wkt)
trap 'rm -rf $tmpdir' EXIT

mkdir -p $tmpdir/google/protobuf
for src in */*.proto; do
  base=$(basename $src .proto)
  target=$(dirname $src)/$base.pb.go
  echo "$src => $target"
  cp $src $tmpdir/google/protobuf
  protoc --plugin=protoc-gen-go=../protoc-gen-go/protoc-gen-go.sh --go_out=paths=source_relative:$tmpdir -I$tmpdir $tmpdir/google/protobuf/$base.proto
  cp $tmpdir/google/protobuf/$base.pb.go $(dirname $src)
done
