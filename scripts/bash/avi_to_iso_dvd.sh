#!/bin/bash

# Gist: Example of burning AVI/MPG into ISO DVD

cat - >sbs.xml <<END 
<dvdauthor>
  <vmgm />
  <titleset>
    <titles>
      <pgc>
        <vob file="sbs.mpg" />
      </pgc>
    </titles>
  </titleset>
</dvdauthor>
END
ffmpeg -i sbs.avi -target ntsc-dvd sbs.mpg
dvdauthor -o . -x sbs.xml
mkisofs -dvd-video -v -o sbs.iso .
growisofs -Z /dev/hdc=sbs.iso 
