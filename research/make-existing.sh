#!/bin/bash
for file in * ; do
	echo -n $file
	grep '^Name' $file.names.auri |
		sed 's/^.*: //'
done
