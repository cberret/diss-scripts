#!/bin/bash
### I use this script to back up my dissertation.
### Its main purpose is to convert the markdown files in a given directory to a PDF.
### Then it sends those to DropBox for safekeeping along with the markdown source files.
### It will also convert those markdown files to HTML and automatically upload them to your personal  web server.
### In all, this is a remarkable service to one's writing, but also a major distrcation from it

#################################
##########  CONFIG  #############
#################################

### LOCAL DIRECTORY INFO ###
filedir="/Users/charles/Cloud/Writing/Dissertation/WorkingFolder" # Where you keep your markdown files on your local machine.
bkdir="/Users/charles/Dropbox/Dissertation-Backups" # local directory to keep backups
latexdir="/Users/charles/Cloud/Writing/Dissertation/ColumbiaFormat"
latexbackupdir="/Users/charles/Cloud/Writing/Dissertation/ColumbiaFormat-Backups"
dropboxdir="/Users/charles/Dropbox"

### LOCAL FILE INFO ###
prefix="Diss_" # Naming prefix for the markdown files you want to use from your main directory.
bibfile="/Users/charles/Cloud/Writing/Dissertation/Biblio/Diss.bib" # your bibtex file
metadata="/Users/charles/Cloud/Writing/Dissertation/WorkingFolder/metadata.yaml" # your yaml file with pandoc metadata. you may also opt to leave this blank and put this info in the header of each markdown file.
css="/Users/charles/Cloud/Writing/Dissertation/WorkingFolder/HTML/style.css" # css style for html page output

### PANDOC AND LATEX VARS ###
template="default" # standard pandoc template
latexengine="xelatex" # standard latex engine for pandoc

### SERVER VARS ###
srv="polytonic.net" # address of your web server. your system should be set up for public key login rather than password.
srvdir="/var/www/diss/chapters/" # Web server directory to send HTML of chapters. Useful if you want your readers to see your most recent progress.
scpdir="/samba/Diss/" # Directory for remote backups of Markdown, LaTeX, PDF, and DOC files.

### MISC VARS ###
date=$(date +%Y%m) ## Timestamp for files and directories. Default is given as year and month, e.g. 201609.

########################################
###########  BEGIN SCRIPT  #############
########################################

## Change to the correct directory
echo "Working in the directory: $filedir"
cd $filedir

## Make PDFs for all Markdown files in the main directory
### Check if there is a PDF directory already. If not, make one. If something named "pdf" already exists but is not a directory, give a warning and quit.
if [[ ! -e $filedir/PDF ]]; then
    mkdir $filedir/PDF
fi
### Same procedure as above, but checks if there is a PDF subdirectory for this month.
if [[ ! -e $filedir/PDF ]]; then
    mkdir $filedir/PDF
fi
if [[ ! -e $filedir/PDF/$date ]]; then
    mkdir $filedir/PDF/$date
fi
for file in $prefix*.md; do
  pandoc "$file" --latex-engine=$latexengine --template=$template  $metadata -o $filedir/PDF/$date/${file%.md}.pdf
done

## If bibtex file is found, make a standalone PDF for the bibliography based on the Bibtex file
if [[ -e $bibfile ]]; then
  pandoc --filter=pandoc-citeproc --latex-engine=$latexengine --template=$template $bibfile -o $filedir/Biblio/$date"_biblio.pdf"
fi
echo

## Combine all active chapters/sections into one PDF
## make a sequential list of Markdown files to pipe to Pandoc
for file in $prefix*.md; do
  mdfiles+="$file "
done
pandoc $mdfiles --latex-engine=$latexengine $metadata -s -o $filedir/PDF/$date/$date"_fulldiss.pdf"

## Convert to DOC files and place in ./DOC directory
### Check for DOC directory, make if missing.
if [[ ! -e $filedir/DOC ]]; then
    mkdir $filedir/DOC
fi
if [[ ! -e $filedir/DOC/$date ]]; then
    mkdir $filedir/DOC/$date
fi
### Make DOC files from Markdown.
for file in $prefix*.md; do
  pandoc $file --template=$template -o $filedir/DOC/$date/${file%.md}.doc
done

## Make HTML from Markdown
### Check for HTML directory, make if missing.
if [[ ! -e $filedir/HTML ]]; then
  mkdir $filedir/HTML
fi
if [[ ! -e $filedir/HTML/$date ]]; then
  mkdir $filedir/HTML/$date
fi
### Make HTML files from Markdown.
for file in *.md; do
  pandoc $file -c $css -o $filedir/HTML/$date/${file%.md}.html
done

## Retain monthly Markdown and Bibtex backups
if [[ ! -e $filedir/MD ]]; then
  mkdir $filedir/MD/$date
fi
if [[ ! -e $filedir/MD/$date ]]; then
  mkdir $filedir/MD/$date
fi
if [[ ! -e $filedir/Biblio ]]; then
  mkdir $filedir/Biblio
fi
for file in $prefix*.md; do
  cp $file $filedir/MD/$date/
done
scp -r $dir $srv:$scpdir
cp Biblio/Diss.bib Biblio/$date_Diss.bib

## Send backups of Markdown, Bibtex, PDF, and DOC files to DropBox...
if [[ -e $dropboxdir ]]; then
  cp -R $filedir/PDF/$date $dropboxdir/
  cp -R $filedir/MD/$date $dropboxdir/
  cp -R $filedir/DOC/$date $dropboxdir/
  cp -R $filedir/Biblio $dropboxdir/
fi
