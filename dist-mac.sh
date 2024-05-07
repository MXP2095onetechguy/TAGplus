#!/bin/sh

# Create and distribute the mac app

# Copy the love app from the /Applications directory to here
cp -r /Applications/love.app .

# Copy the packaged game to the .app
cp TAGplus.love ./love.app/Contents/Resources

# Remove some things from the .app
rm "./love.app/Contents/Resources/OS X AppIcon.icns"
rm "./love.app/Contents/Resources/GameIcon.icns"

# Edit some things here to personalize the copy on the property list with plutil
plutil -replace CFBundleName -string "The Apul Game+" love.app/Contents/Info.plist
plutil -replace CFBundleIdentifier -string "mxpsql.tagplus" love.app/Contents/Info.plist
plutil -remove UTExportedTypeDeclarations love.app/Contents/Info.plist

# Copy icon. We assume you runned icon-mac.sh
cp ./icon.icns "./love.app/Contents/Resources/OS X AppIcon.icns"

# Move ther love.app into a new name
mv love.app tagplus
mv tagplus tagplus.app