#!/bin/bash

lsal()
{
    if [[ -z "$1" ]]; then
	echo 'lsal: missing file operand' 1>&2
	return 1
    fi
    ls -al "$1"
}

lsal ./
echo "return status = $?"
