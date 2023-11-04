#!/bin/bash

# Gist: Generate Random Key

# https://www.linuxquestions.org/questions/linux-newbie-8/can-dd-be-used-to-clone-just-the-data-on-a-partition-595285/

dd if=/dev/random bs=32 count=1 2>/dev/null | od -t x1 | sed  '$d;s/^[[:xdigit:]]* //;s/ //g' | tr -d '\n'; echo
