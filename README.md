# Dissertation Scripts

I use these scripts to convert my dissertation to various other formats, to automatically archive backups, and to track my progress.

To use these scripts yourself, you can get started by inserting the information for your files, folders, and backup servers to the **config_blank.sh** file and saving it as **config.sh**.

The only difference between the two "compile_chapters" scripts is that **compile_chapters_manual.sh** tells you what it's doing and asks for confirmation before it overwrites files. If you want to run these files on a cron job (see example below), or if you don't like reading a stream of text while a script runs, **compile_chapters_auto.sh** is more appropriate.

My plan for the **compile_diss_latex** script is get its output to match Columbia's required dissertation format. Stay tuned.

If you set the **writing_progress.sh** script on a daily cron job (again, see the example below), it will output daily writing progress (words written, words deleted, etc.) for each of the chapters designated in the config file. These are saved to CSV files tracking daily progress for all files and for individual files.


## A Note on Cron Jobs

I find it very useful to run these scripts as cron jobs, which automatically execute commands on a defined schedule. This way I have fresh copies of my chapters, regular progress reports, and plenty of backups.

To write a cron job, enter the command line on your Linux/Mac/BSD/Unix/Posix machine and type:

```
crontab -e
```

Now go to a new line and enter something like this (subbing the actual path to your files, of course):

```
@hourly /path/to/compile_chapters_auto.sh
@midnight /path/to/writing_progress.sh
```
