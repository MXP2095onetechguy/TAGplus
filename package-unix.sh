#!/bin/sh

# Get real path to get the path needed without relativity
PACK="$(realpath TAGplus.love)"
# Go to source directory for zipping
cd src
# Zip it to PACK
zip -9 -r "$PACK" .