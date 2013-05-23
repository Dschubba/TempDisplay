#!/bin/bash

PLATFORM=`uname -s`
WGET="wget"
if [[ "$PLATFORM" == "Darwin" ]]; then
	WGET="/sw/bin/wget"
fi

HOME_DIRECTORY="$HOME/METAR/"

ACTUAL_FILE="EDDM-actual.txt"
DOWNLOADED_FILE="EDDM.TXT"
TARGET_FILE="EDDM-`date "+%Y%m%d%H%M"`.txt"

cd $HOME_DIRECTORY

$WGET -N http://weather.noaa.gov/pub/data/observations/metar/stations/EDDM.TXT -a logfile.txt 

if [ "$ACTUAL_FILE" -ot "$DOWNLOADED_FILE" ]; then
	cp -a $DOWNLOADED_FILE $ACTUAL_FILE
	cp -a $ACTUAL_FILE $TARGET_FILE
fi
