#!/bin/bash

while read package ; do
	file=$(echo $package | cut -d' ' -f1)
	name=$(grep '^Name' menu/$file | sed 's/^.*=//')
	kali_package=$(grep '^X-Kali-Package' menu/$file | sed 's/^.*=//')
	cats=$(grep '^Categories' menu/$file | sed 's/^.*=//')
	term=$(grep '^Terminal' menu/$file | sed 's/^.*=//')

	mkdir -v compiled
	(
	echo Pack=$(echo $package | cut -d' ' -f2)
	echo Name=$name
	echo Kali=$kali_package
	echo Cats=$cats
	echo Term=$term
	) >> compiled/$file
done < existing
