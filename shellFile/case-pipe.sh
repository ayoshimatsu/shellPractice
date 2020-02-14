#!/bin/bash

file="$1"
case "$file" in
    *.sh)
	head "$file"
	;;
    *.tar.gz | *.tgz)
	tar xzf "$file"
	;;
    *)
	echo '???'
	;;
esac
