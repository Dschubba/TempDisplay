#!/usr/bin/env python
#
# simple command-line driver for metar parser
#
import sys, os
from metar import Metar
import string
import getopt
import profile, pstats
import csv

def usage():
    program = os.path.basename(sys.argv[0])
    print "Usage: ", program, "[-s] [<file>]"
    print """Options:
    <files> .. a set of files containing METAR reports to parse
    -q ....... run "quietly" - just report parsing error.
    -s ....... run silently. (no output)
    -p ....... run with profiling turned on.
    -f ....... the outputfile (default is ""output.csv"")
    -j ....... write the output as a javascript array
    This program reads lines containing coded METAR reports from a file
    and prints human-reable reports.  Lines are taken from stdin if no
    file is given.  For testing purposes, the script can run silently,
    reporting only when a METAR report can't be fully parsed.
    """
    sys.exit(1)

files = []
written_values = set()
outputfile = "output.csv"
write_as_javascript = False
silent = False
report = True
debug = False
prof = False

try:
    opts, files = getopt.getopt(sys.argv[1:], 'dpqsjf')
    for opt in opts:
        if opt[0] == '-s':
            silent = True
            report = False
        elif opt[0] == '-q':
            report = False
        elif opt[0] == '-d':
            debug = True
            Metar.debug = True
        elif opt[0] == '-p':
            prof = True
        elif opt[0] == '-j':
            outputfile = "output.js"
            write_as_javascript = True
        elif opt[0] == '-f':
            outputfile = opt[1]
except:
    usage()

def output_to_csv(obs):
    """Writes a single csv line to the output file."""
    if obs.time not in written_values:
        if obs.temp:
            csvfile = open(outputfile, "a")
            outputwriter = csv.writer(csvfile, delimiter=',', quotechar='"')
            outputwriter.writerow([obs.time, obs.temp.value()])
            written_values.add(obs.time)
            csvfile.close()

def output_to_javascript(obs):
    """Writes a single javascript line to the output file."""
    if obs.time not in written_values:
        if obs.temp:
            javascriptfile = open(outputfile, "a")
            javascriptfile.write("['{0}',{1:.1f}],".format(obs.time, obs.temp.value()))
            written_values.add(obs.time)
            javascriptfile.close()

def make_valid_javascript():
    """Opens the written values and makes a valid Javascript array out of it."""
    if write_as_javascript:
        javascriptfile = open(outputfile, "r")
        contents = javascriptfile.read()
        javascriptfile.close()
        javascriptcomplete = "var temperaturePoints = [{0}];".format(contents[:-1])
        javascriptfile = open(outputfile, "w")
        javascriptfile.write(javascriptcomplete)
        javascriptfile.close()


def process_line(line):
    """Decode a single input line."""
    line = line.strip()
    if len(line) and line[0] in string.uppercase:
        try:
            obs = Metar.Metar(line)
            if report:
                print "--------------------"
                print obs.string()
                if write_as_javascript:
                    output_to_javascript(obs)
                else:
                    output_to_csv(obs)
        except Metar.ParserError, err:
            if not silent:
                print "--------------------"
                print "METAR code: ", line
                print string.join(err.args, ", ")

def process_files(files):
    """Decode METAR lines from the given files."""
    if os.path.isfile(outputfile):
        os.remove(outputfile)
    for file in files:
        fh = open(file, "r")
        for line in fh.readlines():
            process_line(line)
        fh.close()

if files:
    if prof:
        profile.run('process_files(files)')
    else:
        process_files(files)
        make_valid_javascript()
else:
    # read lines from stdin 
    while True:
        try:
            line = sys.stdin.readline()
            if line == "":
                break
            process_line(line)
        except KeyboardInterrupt:
            break

if prof:
    ps = pstats.load('metar.prof')
    print ps.strip_dirs().sort_stats('time').print_stats()
