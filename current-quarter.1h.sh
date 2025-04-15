#!/bin/bash

month=$(date +%m)
day_of_year=$(date +%j)
year_progress=$(echo "scale=1; $day_of_year / 365 * 100" | bc)

if [ "$month" -le 3 ]; then
  current="Q1"
  next="Q2"
  end="03-31"
  abbrev_current="Jan–Mar"
  abbrev_next="Apr–Jun"
elif [ "$month" -le 6 ]; then
  current="Q2"
  next="Q3"
  end="06-30"
  abbrev_current="Apr–Jun"
  abbrev_next="Jul–Sep"
elif [ "$month" -le 9 ]; then
  current="Q3"
  next="Q4"
  end="09-30"
  abbrev_current="Jul–Sep"
  abbrev_next="Oct–Dec"
else
  current="Q4"
  next="Q1"
  end="12-31"
  abbrev_current="Oct–Dec"
  abbrev_next="Jan–Mar"
fi

today=$(date +%s)
quarter_end=$(date -j -f "%Y-%m-%d" "$(date +%Y)-$end" +%s 2>/dev/null || date -d "$(date +%Y)-$end" +%s)
days_left=$(( (quarter_end - today) / 86400 ))

echo "$current ($abbrev_current) • $days_left d → $next ($abbrev_next)"
echo "---"
echo "Current quarter: $current ($abbrev_current)"
echo "Next quarter: $next ($abbrev_next)"
echo "Days remaining to next quarter: $days_left d"
echo "Year Progress: $year_progress%"
