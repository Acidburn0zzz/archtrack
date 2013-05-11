#!/bin/bash
# This script moves around a lot, so I'm not going to split it into a script
#  for each function.

all_names() {
	for file in * ; do
		( echo $file
		grep '^Name' $file | sed 's/^.*=//'
		grep '^X-Kali-Package' $file | sed 's/^.*=//' ) | sort -u > names/$file.names
	done
}

info() {
	for file in * ; do
		name=$(grep '^Name' $file | sed 's/^.*=//')
		package=$(grep '^X-Kali-Package' $file | sed 's/^.*=//')
		cats=$(grep '^Categories' $file | sed 's/^.*=//')
		term=$(grep '^Terminal' $file | sed 's/^.*=//')

		echo "$file ~ $name ~ $package ~ $cats ~ $term"
	done
}

discrep() {
	for file in * ; do
		name=$(grep '^Name' $file | sed 's/^.*=//')
		package=$(grep '^X-Kali-Package' $file | sed 's/^.*=//')
		cats=$(grep '^Categories' $file | sed 's/^.*=//')
		term=$(grep '^Terminal' $file | sed 's/^.*=//')

		if [[ $name != $file ]] ; then
			echo "$file has file-name discrepency: $file / $name"
		fi
		if [[ $file != $package ]] ; then
			echo "$file has file-package discrepency: $file / $package"
		fi
	done
}

info_names() {
	for file in * ; do
		found=false
		while read item ; do
			pacman_info=$(pacman -Si "$item" 2>/dev/null)
			if [[ $? = 0 ]] ; then
				tee -a info/$file.paci <<INFO
$pacman_info
INFO
				echo "Found $item."
				found=true
			fi

			aur_info=$(yaourt -Si "$item" 2>/dev/null)
			if [[ $? = 0 ]] ; then
				tee -a info/$file.auri <<INFO
$aur_info
INFO
				echo "Found $item."
				found=true
			fi

			#pacman_search=$(pacman -Ss "$file")
			#if [[ $? = 0 ]] ; then
			#	echo "$pacman_search" | tee -a $file.pacs
			#fi

			#aur_search=$(yaourt -Ss "$file")
			#if [[ $? = 0 ]] ; then
			#	echo "$pacman_info" | tee -a $file.aurs
			#fi
		done < $file

		if $found ; then
			mv $file found
		fi
	done
}

search_norm() {
	for file in * ; do
		aur_info=$(yaourt -Si "$file")
		if [[ $? = 0 ]] ; then
			echo "$pacman_info" | tee -a $file.auri
		fi
		aur_search=$(yaourt -Ss "$file")
		if [[ $? = 0 ]] ; then
			echo "$pacman_info" | tee -a $file.aurs
		fi

		pacman_info=$(pacman -Si "$file")
		if [[ $? = 0 ]] ; then
			echo "$pacman_info" | tee -a $file.pac-info
		fi
		pacman_search=$(pacman -Ss "$file")
		if [[ $? = 0 ]] ; then
			echo "$pacman_search" | tee -a $file.pac-search
		fi
	done
}

info_names
