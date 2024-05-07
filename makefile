#!/usr/bin/make -f

# Base rules
run: # Run raw source
	./run.sh

run-packaged: # Run packaged .love files
	./run-packaged.sh

clean: # clean
	./clean.sh


# OS specific rules
package-unix: # Package for unix platforms
	./package-unix.sh

iconify-mac: # Create icons for macos
	./icon-mac.sh

dist-mac: package-unix iconify-mac # Distribute for macOS
	./dist-mac.sh