#!/bin/bash

TODAY=$(date +%Y%m%d)

SecretUrl="Put your url here"

curl -s $SecretUrl | awk -v today="$TODAY" -F ':' '
$1 ~ /DTSTART/ { start = $2 }
$1 ~ /DTEND/ { end = $2 }
$1 ~ /SUMMARY/ && substr(start,1,8) == today {
	print start "|" end "|" $2
}
' |
while IFS='|' read -r raw_start raw_end summary; do
	local_start=$(date -d "${raw_start:0:8} ${raw_start:9:2}:${raw_start:11:2} UTC" +"%H:%M")
	local_end=$(date -d "${raw_end:0:8} ${raw_end:9:2}:${raw_end:11:2} UTC" +"%H:%M")

	echo "$local_start - $local_end | $summary"
done | sort
