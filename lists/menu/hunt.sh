#!/bin/bash

if [[ $# = 0 ]] ; then
	exit 1
fi

while read item ; do
	echo "  yaourt:"
	yaourt -Ss $item
	echo "  pkgfile:"
	pkgfile $item
done < $1
