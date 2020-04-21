#!/usr/bin/env python3

import os
import time

## if this is your first time running this script, run the three (3) commands below.
## however, rerun the "history -w" one yourself in the terminal. For some reason it doesn't seem to take from python...
# os.system("export HISTTIMEFORMAT=\"%F %T \"")
# os.system("echo '\\nexport HISTTIMEFORMAT=\"%F %T \"' >> ~/.bashrc")
# os.system("history -w")

##"raw.history" is a file with combined timestamped history from terminals.
## Idea is for pentesters to save their command history down, then sync command history.

## reads the "combined" raw history file into script
## change the path below...
file = "</path/to/raw.history/>"

fileread = open(file, 'r')

rawRead = []
modRead = []
finalRead = []
tempList = []

for line in fileread.readlines():
    rawRead.append(line)

for i,s in enumerate(rawRead):
    rawRead[i] = s.strip()

count = 0
while count < len(rawRead):
    modRead.append((rawRead[count] + ',"' + rawRead[count+1] + '"'))
    count += 2

for item in modRead:
    date = item.split(',')[0]
    command = item.split(',')[1]
    newDate = date.strip("#")    # lines start with character we're trying to strip
    finalRead.append(newDate + "," + command)

finalRead.sort()    # this puts the list in order based on EPOCH time
tempList.append(list(dict.fromkeys(finalRead)))    # this removes dup's from list
finalRead = tempList    # sets the final list

count = 0
while count < len(finalRead[0]):
    rawTime = finalRead[0][count].split(',')[0]
    command = finalRead[0][count].split(',')[1]
    timestamp = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(int(rawTime)))
    count += 1
    print(str(timestamp) + ' ' + str(command))
    
