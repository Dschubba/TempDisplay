#!/bin/bash

# On which platform do we run? We decide to use which wget later...
PLATFORM=`uname -s`
WGET="wget"
WGET_LOGFILE="logfile.txt"

# Where to store the METAR-Data
HOME_DIRECTORY="$HOME/METAR/"

# Holds the file which is last stored - this is 
ACTUAL_FILE="EDDM-actual.txt"
# compared to this file
DOWNLOADED_FILE="EDDM.TXT"
# This is where we store the files for that day
TARGET_DIRECTORY="$HOME_DIRECTORY/`date "+%Y"`/`date "+%m"`/`date "+%d"`"
# The filename of the new file - actually this is copied from the "ACTUAL_FILE"
TARGET_FILE="EDDM-`date "+%Y%m%d%H%M"`.txt"

if [[ "$PLATFORM" == "Darwin" ]]; then
	WGET="/sw/bin/wget"
fi

cd $HOME_DIRECTORY
mkdir -p $TARGET_DIRECTORY

$WGET -N http://weather.noaa.gov/pub/data/observations/metar/stations/EDDM.TXT -a $WGET_LOGFILE

if [ "$ACTUAL_FILE" -ot "$DOWNLOADED_FILE" ]; then
	cp -a $DOWNLOADED_FILE $ACTUAL_FILE
	cp -a $ACTUAL_FILE "$TARGET_DIRECTORY/$TARGET_FILE"
fi

