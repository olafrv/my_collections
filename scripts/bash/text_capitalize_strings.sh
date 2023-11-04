#!/bin/bash

# Capitalize words

function toCapital
{
   for x in $*
   do
	  echo -n ${x:0:1} | tr '[a-z]' '[A-Z]' | xargs echo -n
	  echo -n ${x:1} | tr '[A-Z]' '[a-z]' | xargs echo -n
	  echo -n " "
   done
}

toCapital yuCa aMigo
# Yuca Amigo