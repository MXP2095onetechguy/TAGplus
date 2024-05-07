#!/bin/bash

# Produce .icns files for the MacOS version of TAG+

# Copy icon here
cp ./src/assets/image/icon.png ./icon.gitignored.png

# Create an icon mapping sheet
cat > iconmap.gitignored.txt << EOF
i=e
EOF

# Make iconset directory
mkdir -p iconset.gitignored.icnset

iconutil -c icns iconset.gitignored.icnset