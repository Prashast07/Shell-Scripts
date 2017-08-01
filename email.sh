#!/bin/bash
echo "Enter a filename to read:"
read FILE
while read line; do
	email="$(grep -i -o '[A-Z0-9._%+-]\+@[A-Z0-9.-]\+\.[A-Z]\{2,4\}' <<< "$line")"
	echo "$email"
done < $FILE

