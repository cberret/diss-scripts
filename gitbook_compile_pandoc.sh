#!/usr/local/bin/bash

filedir='/Users/charles/Cloud/Writing/Gitbooks/cberret/diss'
outputdir='/Users/charles/Cloud/Writing/Dissertation/MostRecent'
metadata='metadata.yaml'
date=$(date +%Y%m)

cd $filedir
echo "working out of the $filedir directory"
echo
awk 'NR > 1 {print $1}' RS='(' FS=')' $filedir/SUMMARY.md > ../sectionlist.tmp

frontmatter=$(awk '/frontmatter/ {printf $0 " "}' ../sectionlist.tmp)
echo -e "frontmatter files are: \n$frontmatter"
echo
intro=$(awk '/introduction/ {printf $0 " "}' ../sectionlist.tmp)
echo -e "introduction files are: \n$intro"
echo
litreview=$(awk '/litreview/ {printf $0 " "}' ../sectionlist.tmp)
echo -e "lit review files are: \n$litreview"
echo
chapter1=$(awk '/chapter1/ {printf $0 " "}' ../sectionlist.tmp)
echo -e "chapter 1 files are: \n$chapter1"
echo
chapter2=$(awk '/chapter2/ {printf $0 " "}' ../sectionlist.tmp)
echo -e "chapter 2 files are: \n$chapter2"
echo
chapter3=$(awk '/chapter3/ {printf $0 " "}' ../sectionlist.tmp)
echo -e "chapter 3 files are: \n$chapter3"
echo
chapter4=$(awk '/chapter4/ {printf $0 " "}' ../sectionlist.tmp)
echo -e "chapter 4 files are: \n$chapter4"
echo
# chapter5=$(awk -v '/chapter5/ {printf $0 " "}' ../sectionlist.tmp)
# echo -e "chapter 5 files are: \n$chapter5"
# echo
conclusion=$(awk '/conclusion/ {printf $0 " "}' ../sectionlist.tmp)
echo -e "conclusion files are: \n$conclusion"
echo

echo "pandoc -- frontmatter"
pandoc README.md $frontmatter --latex-engine=xelatex $metadata -o $outputdir/$date'_frontmatter.pdf'
echo "pandoc -- introduction"
pandoc $intro --latex-engine=xelatex $metadata -o $outputdir/$date'_introduction.pdf'
echo "pandoc -- lit review"
pandoc $litreview --latex-engine=xelatex $metadata -o $outputdir/$date'_litreview.pdf'
echo "pandoc -- chapter 1"
pandoc $chapter1 --latex-engine=xelatex $metadata -o $outputdir/$date'_chapter1.pdf'
echo "pandoc -- chapter 2"
pandoc $chapter2 --latex-engine=xelatex $metadata -o $outputdir/$date'_chapter2.pdf'
echo "pandoc -- chapter 3"
pandoc $chapter3 --latex-engine=xelatex $metadata -o $outputdir/$date'_chapter3.pdf'
echo "pandoc -- chapter 4"
pandoc $chapter4 --latex-engine=xelatex $metadata -o $outputdir/$date'_chapter4.pdf'
#echo "pandoc for chapter 5"
# pandoc $chapter5 --latex-engine=xelatex $metadata -o $outputdir/$date'_chapter5.pdf'
# echo "pandoc for conclusion"
pandoc $conclusion --latex-engine=xelatex $metadata -o $outputdir/$date'_conclusion.pdf'
# echo "pandoc for manual bibliography -- not bibtex"
echo "pandoc -- bibliogrpahy"
pandoc bibliography.md --latex-engine=xelatex $metadata -o $outputdir/$date'_bibliography.pdf'

echo "now pandoc the entire diss"
## separare vars for each chapter to keep page breaks
pandoc README.md $front $intro $litreview $chapter1 $chapter2 $chapter3 $chapter4 $conclusion bibliography.md --latex-engine=xelatex $metadata -o $outputdir/$date'_berret_fulldraft.pdf'
echo

##backups
echo "copy backups to owncloud and dropbox"
mkdir /Users/charles/Cloud/Writing/Dissertation/Backups/PDF/$date
cp $outputdir/* /Users/charles/Cloud/Writing/Dissertation/Backups/PDF/$date/
mkdir /Users/charles/Dropbox/ColumbiaDiss/PDF/$date
cp $outputdir/* /Users/charles/Dropbox/ColumbiaDiss/PDF/$date/

rm ../sectionlist.tmp

echo
echo "finished!"
