for cat in {01..14} ; do
	grep -l "Cats.*$cat-..-" compiled/* |
	while read file ; do
		grep '^Pack' $file |
		sed 's/^.*=//' >> cats/$(grep -m1 "^$cat" ../menu/sections)
	done 
done
