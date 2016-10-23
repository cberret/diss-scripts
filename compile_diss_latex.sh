#!/bin/sh

#################################
##########  CONFIG  #############
#################################

### DIRECTORIES
dir="/Users/charles/Cloud/Writing/Dissertation/WorkingFolder" # Where you keep your markdown files on your local machine.
backupdir="/Users/charles/Dropbox"

### MATCH MARKDOWN FILES TO LATEX TEMPLATE
titlepage="Diss_0_Title.md"
abstract=""
acknowledgments="Diss_1_Ackn.md"
copyright=""
dedication=""
introduction="Diss_2_Intro.md"
litreview="Diss_3_LitReview.md"
chapter1="Diss_Ch1.md"
chapter2="Diss_Ch2.md"
chapter3="Diss_Ch3.md"
chapter4="Diss_Ch4.md"
conclusion="Diss_Y_Conclusion.md"

### BIBLIOGRAPHY
bibfile="/Users/charles/Cloud/Writing/Dissertation/Biblio/Diss.bib" # your bibtex file

### PANDOC AND LATEX VARIABLES
template="default" # standard pandoc template
latexengine="xelatex" # standard latex engine for pandoc
metadata="/Users/charles/Cloud/Writing/Dissertation/WorkingFolder/metadata.yaml" # your pandoc metadata yaml file. you may also opt to put this info in the header for each markdown file.

date=$(date +%Y%m) ## Timestamp for files and directories. Default is given as year and month, e.g. 201609.

########################################
###########  BEGIN SCRIPT  #############
########################################

echo
## Make LaTeX for chapters
if [[ ! -e $dir/ColumbiaDiss ]]; then
    mkdir $dir/ColumbiaDiss
    echo -e "Created dissertation LaTeX directory at: \n$dir/ColumbiaDiss"
fi
echo "Converting Markdown to LaTeX with Pandoc and saving to: \n$dir/ColumbiaDiss"
pandoc $dir/$titlepage --chapters -o $dir/ColumbiaDiss/FrontMatter/TitlePage.tex
pandoc $dir/$acknowledgments --chapters -o $dir/ColumbiaDiss/FrontMatter/Acknowledgments.tex
pandoc $dir/$introduction --chapters -o $dir/ColumbiaDiss/Introduction/Introduction.tex
pandoc $dir/$litreview --chapters -o $dir/ColumbiaDiss/Introduction/LitReview.tex
pandoc $dir/$chapter1 --chapters -o $dir/ColumbiaDiss/Chapter1/Chapter1.tex
pandoc $dir/$chapter2 --chapters -o $dir/ColumbiaDiss/Chapter1/Chapter2.tex
pandoc $dir/$chapter3 --chapters -o $dir/ColumbiaDiss/Chapter1/Chapter3.tex
pandoc $dir/$chapter4 --chapters -o $dir/ColumbiaDiss/Chapter1/Chapter4.tex
pandoc $dir/$conclusion --chapters -o $dir/ColumbiaDiss/Conclusion/Conclusion.tex
echo

#### fix a few formatting details with pandoc's latex output
# sed -i '/\chapter/ *'$dir/Introduction/Introduction.tex
# sed -i '2i\addcontentsline{toc}{chapter}{Introduction}' $dir/Introduction/Introduction.tex
# sed -i '2i\addcontentsline{toc}{chapter}{LitReview}' $dir/Introduction/LitReview.tex
# sed -i '2i\addcontentsline{toc}{chapter}{Conclusion}' $dir/Conclusion/Conclusion.tex

## Make local backups of LaTeX files
echo "Archiving LaTeX files locally..."
if [[ ! -e $backupdir/ColumbiaDiss ]]; then
    mkdir $backupdir/ColumbiaDiss
    echo -e "Created LaTeX backup directory at: \n$backupdir/ColumbiaDiss"
fi
if [[ ! -e $backupdir/ColumbiaDiss/$date/ ]]; then
    mkdir $backupdir/ColumbiaDiss/$date/
    echo -e "Created monthly LaTeX backup directory at: \n$backupdir/ColumbiaDiss/$date"
fi
cp -R $dir/ColumbiaDiss/* $backupdir/ColumbiaDiss/$date/
echo "Sent backups to $backupdir/$date/"
echo

## Send LaTeX backups to server via SCP. Comment the following section if unwanted.
# echo "Sending LaTeX files to server over SCP..."
# scp -r $dir $scpdir
# scp $bibfile $scpdir/$date"_bib.tex"
# echo

echo "Chapters are now ready to compile from LaTeX!"
echo
