#!/bin/bash -vx

if [$# -ne 1]; then
    echo "usage: generate_rotated_image.sh greyscale_256_image"
    exit 1
fi

filename="$(realpath "$1")"


OUTPUT_DIR=$(pwd)

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

WORK_DIR=$(mktemp -d)

if [[ ! "$WORK_DIR" || ! -d "$WORK_DIR" ]]; then
  echo "Could not create temp dir"
  exit 1
fi

function cleanup {      
  rm -rf "$WORK_DIR"
}
trap cleanup EXIT

cd "$WORK_DIR"
"$SCRIPT_DIR/rotateNPP" -input "$filename"
FILENAME_NO_SUFFIX="${filename%.*}"
OUTFILE="$OUTPUT_DIR/$(basename $FILENAME_NO_SUFFIX)-spinning.gif"

convert -delay 5 -loop 0 rotation_*.pgm $OUTFILE
