#!/bin/bash

# Produce .icns files for the MacOS version of TAG+

# Copy icon here
cp ./src/assets/image/icon.png ./icon.gitignored.png

# Create an icon mapping sheet for automation purposes
# Format - Filename=Size
cat > iconmap.gitignored.txt << EOF
icon_16x16.png=16x16
icon_16x16@2x.png=32x32
icon_32x32.png=32x32
icon_32x32@2x.png=64x64
icon_128x128.png=128x128
icon_128x128@2x.png=256x256
icon_256x256.png=256x256
icon_256x256@2x.png=512x512
icon_512x512.png=512x512
icon_512x512@2x.png=1024x1024
EOF

# Make iconset directory
mkdir -p icnsset.gitignored.iconset

while IFS="=" read -r filenam size; do
    magick convert ./icon.gitignored.png -resize $size "./icnsset.gitignored.iconset/$filenam"
done < iconmap.gitignored.txt

iconutil -c icns icnsset.gitignored.iconset -o icon.icns