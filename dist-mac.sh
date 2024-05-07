#!/bin/sh
cp -r /Applications/love.app .
cp TAGplus.love ./love.app/Contents/Resources
plutil -replace CFBundleName -string "The Apul Game+" love.app/Contents/Info.plist
plutil -replace CFBundleIdentifier -string "mxpsql.tagplus" love.app/Contents/Info.plist
plutil -remove UTExportedTypeDeclarations love.app/Contents/Info.plist