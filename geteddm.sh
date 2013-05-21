#!/bin/bash
wget http://weather.noaa.gov/pub/data/observations/metar/stations/EDDM.TXT -O $HOME/METAR/EDDM-`date  "+%Y%m%d%H%M"`.txt -a $HOME/METAR/logfile.txt
