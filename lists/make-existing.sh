#!/bin/bash
for file in * ; do
	echo -n phrasendrescher.names
	grep '^Name' phrasendrescher.names.auri |
		sed 's/^.*: //'
done
