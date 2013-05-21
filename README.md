TempDisplay
===========

Small package of programs for converting and showing temperature curves using JSPlot and Raspberry PI. The PI fetches the temperatures
from a airport nearby and converts the data.

The rendering is done in the browser.

This uses the METAR-Parsing Library available at https://pypi.python.org/pypi/metar/ - this is used for parsing the different METARs.

geteddm.sh
----------

This is only a simple stupid script to fetch the data from the official server - this will be a more sophisticated version in the future,
 but currently it is only a dirty hack, with fetches the data for the Munich Airport (or EDDM in METAR-Speak)

convert_metar.py
----------------

This is my first try to parse different METAR files in python (which are fetched by "geteddm.sh"). It converts the different METAR-Files 
to a output.csv or if you like in a includeable output.js.

The output is normally without options written to "output.js".

plot
----

Contains all files for plotting a temperature curve with JQPlot - this is also a quick and dirty version, but it works for me now.
Just load the plottemperature.html in you browser - and if a "output.js" is found in the upper directory it will plot this values.

- Dschubba 2013-05-21