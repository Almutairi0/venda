#!/bin/bash

TODAY=$(date +%Y%m%d)
NOW=$(date +%s)
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
' | sort |
	while IFS='|' read -r raw_start raw_end summary; do
	local_start=$(date -d "${raw_start:9:2}:${raw_start:11:2} UTC" +"%H:%M")
	local_end=$(date -d "${raw_end:9:2}:${raw_end:11:2} UTC" +"%H:%M")

	start_seconds=$(date -d "${raw_start:9:2}:${raw_start:11:2} UTC" +"%s")
	elapsed=$((start_seconds - NOW))
	if [ $elapsed -lt 0 ]; then
		continue
	elif [ $elapsed -lt 3600 ]; then
		echo -e "\e[31m$local_start - $local_end | $summary\e[0m"
	elif [ $elapsed -lt 10800 ]; then
		echo -e "\e[33m$local_start - $local_end | $summary\e[0m"
	else
		echo -e "\e[32m$local_start - $local_end | $summary\e[0m"
fi

done
