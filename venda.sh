#!/bin/bash

TODAY=$(date +%Y%m%d)

SecretUrl="Put your url here"

curl -s $SecretUrl | awk -v today="$TODAY" -F ':' '
$1 ~ /DTSTART/ { start = $2 }
$1 ~ /DTEND/ { end = $2 }
$1 ~ /SUMMARY/ && substr(start,1,8) == today {
	##substr(text, start_position, how_many_characters)
	#$2: This is the text it is looking at (20260602T110000Z).
	#1: This tells it where to put its finger to start counting. Position 1 is the very first character, which is the
	#8: This tells it how many characters to count out to the right.
	print start "|" end "|" $2
	
}
' |
while IFS='|' read -r raw_start raw_end summary; do
	local_start=$(date -d "${raw_start:9:2}:${raw_start:11:2} UTC" +"%H:%M")
	local_end=$(date -d "${raw_end:9:2}:${raw_end:11:2} UTC" +"%H:%M")

	echo "$local_start - $local_end | $summary"
done | sort
