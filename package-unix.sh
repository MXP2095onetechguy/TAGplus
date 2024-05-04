#!/bin/sh

PACK="$(realpath TAGplus.love)"
cd src
zip -9 -r "$PACK" .