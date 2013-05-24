#!/bin/bash
# This little script fetches data from the official METAR-Weather data server
# and stores it for later processing.
# Copyright (C) 2013 Wolfram Sobotta <w.sobotta@lesath.de>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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

# Special treatment for Mac-Wget...
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

