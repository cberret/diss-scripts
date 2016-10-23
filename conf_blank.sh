#!/bin/bash

#################################
##########  CONFIG  #############
#################################

### LOCAL DIRECTORY INFO ###
filedir="/path/to/dissertation" # path to your dissertation markdown files.
bkdir="/path/to/backupdirectory" # full path to local directory for MD, DOC, HTML, and PDF backups.
latexdir="/path/to/latex" # full path to local directory for saving latex files. this directory will be automatically created if it does not already exist.
latexbackupdir="/path/to/latexbackups" # full path to local directory for latex backups. this directory will be automatically created if it does not already exist.
dropboxdir="/path/to/dropbox" # full path to local dropbox directory

### LOCAL FILE INFO ###
prefix="" # Naming prefix for the markdown files you want to use from your main directory, e.g. "diss_".
bibfile="/path/to/file.bib" # full path to your bibtex file
metadata="/path/to/file.yaml" # full path to yaml file with pandoc metadata. you may also opt to leave this blank and put this info in the header of each markdown file.
css="/path/to/file.css" # full path to css styles for html page output.

### PANDOC AND LATEX VARS ###
template="default" # name of the pandoc template you wish to use
latexengine="xelatex" # name of the latex engine you wish to use

### SERVER VARS ###
srv="" # address of your web server. this system should be set up for automatic public key authentication rather than password login.
srvdir="" # the directory on your web server to send HTML of chapters, e.g. /var/www/diss/ . useful if you want your most recent changes to be automatically visible to your readers.
scpdir="" # Directory for remote backups of Markdown, LaTeX, PDF, and DOC files.

### MISC VARS ###
date=$(date +%Y%m) ## Timestamp for files and directories. Default is given as year and month, e.g. 201610.