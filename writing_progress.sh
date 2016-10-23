#!/bin/bash

### LOCAL DIRECTORY INFO ###
filedir="/Users/charles/Cloud/Writing/Dissertation/WorkingFolder"
dailies="$filedir/MD/daily"
prefix="Diss_"
today=$(date +%Y%m%d)
yesterday=$(date -v-1d +%Y%m%d)

## change to main file directory
cd $filedir

if [[ ! -e $filedir/MD ]]; then
  mkdir $filedir/MD
fi
if [[ ! -e $filedir/MD/daily ]]; then
  mkdir $filedir/MD/daily
fi
if [[ ! -e $filedir/MD/changelog ]]; then
  mkdir $filedir/MD/changelog
fi

echo
## copy dated markdown files to directory of daily backups
echo -e "Copying files to daily folder at ./MD/daily/ "
for file in $prefix*.md; do
  cp $file $dailies/$today"_"$file
  # echo -e "copying $file as today's most recent version."
done
echo

## For debugging: list files for yesterday and today.
# echo -e "Yesterday's files: "
# for file in ./MD/daily/$today*.md; do
#   echo "$file"
# done
# echo
# echo -e "Today's files:"
# for file in ./MD/daily/$yesterday*.md; do
#   echo "$file"
# done

echo -e "Comparing files..."
for file in $prefix*.md; do
  # echo -e "looking at $file on $today and $yesterday"
  # printf "$today " >> $filedir/MD/changelog/"dailychanges_"$today".csv"
  wdiff -s123 $dailies/$yesterday"_"$file $dailies/$today"_"$file >> $filedir/MD/changelog/"dailychanges_"$today".csv"
  echo -e "--> $yesterday"_"$file /// $today"_"$file"
# cat $filedir/MD/changelog/"allchanges_"$today".md"
done
for file in $prefix*.md; do
  # echo -e "looking at $file on $today and $yesterday"
  # printf "$today " >> $filedir"/MD/changelog/allchanges.csv"
  wdiff -s123 $dailies/$yesterday"_"$file $dailies/$today"_"$file >> $filedir"/MD/changelog/allchanges.csv"
done
# for file in $prefix*.md; do
#   # echo -e "looking at $file on $today and $yesterday"
#   wdiff -s123 $dailies/$yesterday"_"$file $dailies/$today"_"$file >> $filedir"/MD/changelog/"$file
# done
echo
echo -e "New and updated wdiff CSV files can be found in: "
echo -e "+++ $filedir"/MD/changelog/""
echo

# echo -e "Today's files:"
# for file in $yesterday*.md; do
#   echo "$file"
# done
