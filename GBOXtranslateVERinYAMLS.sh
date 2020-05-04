#!/usr/bin/env bash
# Executed inside of a building gbox and assumes VER set

echo "Translating in *.yaml: {VER} to $VER"
echo "Translating in *.yaml: {GBOX} to $GBOX"
GBOXescaped="$(echo $GBOX | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')"

find . -name "*.yaml" -exec sed -i "s/{VER}/$VER/g" {} +
find . -name "*.yaml" -exec sed -i "s/{GBOX}/$GBOXescaped/g" {} +
