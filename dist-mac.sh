#!/bin/sh

# Create and distribute the mac app

# Copy the love app from the /Applications directory to here
cp -r /Applications/love.app .

# Copy the packaged game to the .app
cp TAGplus.love ./love.app/Contents/Resources

# Edit some things here to personalize the copy on the property list with plutil
plutil -replace CFBundleName -string "The Apul Game+" love.app/Contents/Info.plist
plutil -replace CFBundleIdentifier -string "mxpsql.tagplus" love.app/Contents/Info.plist
plutil -remove UTExportedTypeDeclarations love.app/Contents/Info.plist