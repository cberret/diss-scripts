#!/usr/local/bin/bash

filedir='/Users/charles/Cloud/Writing/Gitbooks/cberret/diss'
backupdir='/Users/charles/Cloud/Writing/Dissertation/Backups/MD'
dropboxdir='/Users/charles/Dropbox/ColumbiaDiss/MD'

date=$(date +%Y%m%d)

echo -e "make a directory for today's date:\n$backupdir/$date"
mkdir $backupdir/$date
echo -e "copy md files in gitbooks directory to:\n$backupdir/$date"
cp $filedir/*.md $backupdir/$date/
echo -e "make a directory for today's date:\n$dropboxdir/$date"
mkdir $dropboxdir/$date
echo -e "copy md files in gitbooks directory to:\n$dropboxdir/$date"
cp $filedir/*.md $dropboxdir/$date/

echo
echo -e "finished!"





