# logman
A CLI log manager for HTML chatlogs

Includes two scripts:
## xtract
Used for logfile movements, automatically placing them in new, consecutively numbered session folders

Commands include:
* zip - specifies a zipfile to unzip into a session
* match - specifies a pattern to match files by

## srch
Used to browse logfiles

Commands include:
* exec - execute shell command on all logfiles whose name matches PATTERN
* fulltext - full text search for logfile lines matching PATTERN
* name - list logfiles whose name matches PATTERN

## Configuration
logman is meant to be platform independent and allow custom folder structures. These are managed via `.ndexconf.yml`.

## Dependencies
* the_silver_searcher
* UNIX terminal
