#!/bin/sh

set -eu

filename=$1
shift
typst watch "src/$filename.typ" "target/$filename.pdf" "$@"
