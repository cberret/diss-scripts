#!/bin/bash
### I use this script to back up my dissertation.
### Its main purpose is to convert the markdown files in a given directory to a PDF.
### Then it sends those to DropBox for safekeeping along with the markdown source files.
### It will also convert those markdown files to HTML and automatically upload them to your personal  web server.
### In all, this is a remarkable service to one's writing, but also a major distraction from it!

#################################
##########  CONFIG  #############
#################################

### LOCAL DIRECTORY INFO ###
filedir="/path/to" # Where you keep your markdown files on your local machine.
bkdir="/path/to" # local directory to keep backups
latexdir="/path/to"
latexbackupdir="/path/to"
dropboxdir="/path/to"

### LOCAL FILE INFO ###
prefix="Diss_" # Naming prefix for the markdown files you want to use from your main directory.
bibfile="/path/to/Diss.bib" # your bibtex file
metadata="/path/to/metadata.yaml" # your yaml file with pandoc metadata. you may also opt to leave this blank and put this info in the header of each markdown file.
css="/path/to/style.css" # css style for html page output

### PANDOC AND LATEX VARS ###
template="default" # standard pandoc template
latexengine="xelatex" # standard latex engine for pandoc

### SERVER VARS ###
srv="example.net" # address of your web server. your system should be set up for public key login rather than password.
srvdir="/var/www/diss" # Web server directory to send HTML of chapters. Useful if you want your readers to see your most recent progress.
scpdir="/samba/" # Directory for remote backups of Markdown, LaTeX, PDF, and DOC files using Samba.

### MISC VARS ###
date=$(date +%Y%m) ## Timestamp for files and directories. Default is given as year and month, e.g. 201609.

########################################
###########  BEGIN SCRIPT  #############
########################################

## Some encouragement!!
echo
echo "This script will turn your Markdown files into other publishable formats."
echo "Since you're running this script, you must be making progress on your dissertation!"
echo
sleep 1

## Change to the correct directory
echo "Working in the directory: $filedir"
cd $filedir
echo
sleep .2

## Warning that this program overwrites by default
echo "How to use this script:"
echo "- Begin by editing the variables in the CONFIG section of this file."
echo "- This script will auomatically convert your Markdown files into PDFs, DOCs, HTML, and LaTeX."
echo "- It also makes a ridiculous number of backups."
echo "- By default, this script will begin a new version of a file each month. In other words, each time you run the script, it will overwrite previous versions of the same file from that month."
echo
sleep .2

read -p "Do you want to see a list of the files that you are about to overwrite? (y/N): " choice
case "$choice" in
  y|Y|yes|Yes ) echo "Here they are:"
    for file in $filedir/MD/$date/*.md; do
      echo "--  $file"
    done
    for file in $filedir/PDF/$date/*.pdf; do
      echo "--  $file"
    done
    for file in $filedir/DOC/$date/*.doc; do
      echo "--  $file"
    done
    for file in $filedir/HTML/$date/*.html; do
      echo "--  $file"
    done;;
  n|N|no|No ) echo "Moving on...";;
  * ) echo "invalid";;
esac
echo
read -p "Continue and make new files? (y/N): " overwrite
case "$overwrite" in
  y|Y|yes|Yes ) echo "OK, fresh files coming right up...";;
  n|N|no|No ) echo; echo "*** You've quit the script."; echo; exit 1;;
  * ) echo "invalid";;
esac
sleep .5
echo

## Make PDFs for all Markdown files in the main directory
echo -e "Making PDFs from each of your Markdown files and saving them to: \n$filedir/PDF/$date/"
### Check if there is a PDF directory already. If not, make one. If something named "pdf" already exists but is not a directory, give a warning and quit.
if [[ ! -e $filedir/PDF ]]; then
    mkdir $filedir/PDF
fi
### Same procedure as above, but checks if there is a PDF subdirectory for this month.
if [[ ! -e $filedir/PDF ]]; then
    mkdir $filedir/PDF
    echo "Create directory at ./PDF"
fi
if [[ ! -e $filedir/PDF/$date ]]; then
    mkdir $filedir/PDF/$date
    echo "Create directory at ./PDF/$date"
fi
for file in $prefix*.md; do
  echo "*** $date"_"${file%.md}.pdf"
  pandoc "$file" --latex-engine=$latexengine --template=$template  $metadata -o $filedir/PDF/$date/${file%.md}.pdf
done
echo

## If bibtex file is found, make a standalone PDF for the bibliography based on the Bibtex file
if [[ -e $bibfile ]]; then
  echo "Making a PDF of the bibliography and saving to: \n$filedir/Biblio"
  pandoc --filter=pandoc-citeproc --latex-engine=$latexengine --template=$template $bibfile -o $filedir/Biblio/$date"_biblio.pdf"
  echo
else echo "Did not find a Bibtex file. Moving on..."
fi
echo

## Combine all active chapters/sections into one PDF
echo "Collating chapters and sections into one PDF in this order..."
## make a sequential list of Markdown files to pipe to Pandoc
for file in $prefix*.md; do
  mdfiles+="$file "
  echo "- $file"
done
pandoc $mdfiles --latex-engine=$latexengine $metadata -s -o $filedir/PDF/$date/$date"_fulldiss.pdf"
echo
echo -e "Full dissertation collated and saved to: \n$filedir/PDF/$date"_"fulldiss.pdf"
echo

## Convert to DOC files and place in ./DOC directory
### Check for DOC directory, make if missing.
if [[ ! -e $filedir/DOC ]]; then
    mkdir $filedir/DOC
    echo "Created directory at ./DOC"
fi
if [[ ! -e $filedir/DOC/$date ]]; then
    mkdir $filedir/DOC/$date
    echo "Create directory at ./DOC/$date"
fi
### Make DOC files from Markdown.
echo -e "Making DOC files and saving them to: \n$filedir/DOC/$date/"
for file in $prefix*.md; do
  pandoc $file --template=$template -o $filedir/DOC/$date/${file%.md}.doc
  echo "***  ./DOC/$date/${file%.md}.doc"
done
echo

## Make HTML from Markdown
### Check for HTML directory, make if missing.
if [[ ! -e $filedir/HTML ]]; then
  mkdir $filedir/HTML
  echo "Created directory at ./HTML"
fi
if [[ ! -e $filedir/HTML/$date ]]; then
  mkdir $filedir/HTML/$date
  echo "Create directory at ./HTML/$date"
fi
### Make HTML files from Markdown.
echo -e "Converting to HTML and saving to: \n$filedir/HTML/"
for file in *.md; do
  pandoc $file -c $css -o $filedir/HTML/$date/${file%.md}.html
  echo "***  ${file%.md}.html"
done
echo

## Retain monthly Markdown and Bibtex backups
if [[ ! -e $filedir/MD ]]; then
  mkdir $filedir/MD/$date
  echo "Created directory at $filedir/MD/$date"
fi
if [[ ! -e $filedir/MD/$date ]]; then
  mkdir $filedir/MD/$date
  echo "Created directory at $filedir/MD/$date"
fi
if [[ ! -e $filedir/Biblio ]]; then
  mkdir $filedir/Biblio
  echo "Created directory at $filedir/Biblio"
fi
echo -e "Archiving Markdown files to: \n$filedir/MD/$date/"
for file in $prefix*.md; do
  cp $file $filedir/MD/$date/
  echo "***  $file"
done
echo
echo -e "Archiving Bibliography to: \n$filedir/Biblio/$date"_"Diss.bib"
scp -r $dir $srv:$scpdir
cp Biblio/Diss.bib Biblio/$date_Diss.bib
echo

## Send backups of Markdown, Bibtex, PDF, and DOC files to DropBox...
if [[ -e $dropboxdir ]]; then
  echo "Sending PDF, Markdown, Biblio and DOC backups to DropBox..."
  cp -R $filedir/PDF/$date $dropboxdir/
  echo "- PDFs sent to Dropbox"
  cp -R $filedir/MD/$date $dropboxdir/
  echo "- Markdown sent to Dropbox"
  cp -R $filedir/DOC/$date $dropboxdir/
  echo "- DOCs sent to Dropbox"
  cp -R $filedir/Biblio $dropboxdir/
  echo "- Biblio sent to Dropbox"
else "No Dropbox directory found in config. Moving on..."
fi
echo

echo "All finished!"
