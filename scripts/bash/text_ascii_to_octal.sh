#!/bin/bash

# Gist: Example ASCII string to Octal in BASH

x="base de dátos"

function octal {
	ascii=$(echo -n "$1" | iconv -t ASCII//TRANSLIT -f UTF-8)
	for (( i=0; i<${#ascii}; i++ )); do
		printf '\\%03o' $(printf '%d' \'${ascii:$i:1})
	done
}

y=$(octal "$x")
printf $y
