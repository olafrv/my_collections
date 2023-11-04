#!/bin/bash

# Gist: Modify CONTROL file in Debian Package

# Suppose you have your-package.deb file and want to change files inside the package:

mkdir -p tmp/DEBIAN
dpkg-deb -x your-package.deb tmp/
dpkg-deb --control your-package.deb tmp/DEBIAN

# Modify the file tmp/DEBIAN/control as you like it. 

dpkg-deb -b tmp your-package-custom.deb

# Finally

dpkg -i your-package-custom.deb
