# Dissertation Scripts

I use these scripts to convert my dissertation to various other formats, to automatically archive backups, and to track my progress.

To use these scripts yourself, you can get started by inserting the information for your files, folders, and backup servers to the **config_blank.sh** file and saving it as **config.sh**.

The only difference between the two "compile_chapters" scripts is that **compile_chapters_manual.sh** tells you what it's doing and asks for confirmation before it overwrites files. If you want to run these files on a cron job, or if you don't like reading a stream of text while a script runs, **compile_chapters_auto.sh** is more appropriate.

My plan for the **compile_diss_latex** script is get its output to match Columbia's required dissertation format. Stay tuned.

The **writing_progress.sh** script outputs daily writing progress (words written, words deleted, etc.) for each of the chapters designated in the config file. These are saved to CSV files tracking daily progress for all files and for individual files.
