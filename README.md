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
* list - list logfiles matching a particular pattern in their name
* last - find the last logfile matching a pattern
* text - full text search on logfile lines

## Configuration
logman is meant to be platform independent and allow custom folder structures. These are managed via `.ndexconf.yml`.

## Dependencies
* the_silver_searcher
* UNIX terminal
