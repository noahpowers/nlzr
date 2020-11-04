#!/usr/bin/python3
############################################################################
### Written by Noah Powers                                                 #
###                                                                        #
############################################################################
###                                                                        #
### Returns the status of beacons that have phoned home.                   #
###                                                                        #
############################################################################

import os
import subprocess

query = "grep -r -i 'checkin' | grep -E -i -v '(task|input|unknown|keystroke|checking)' | cut -d'/' -f2-4 | cut -d':' -f1-4 | sed 's/\//\ /g' | sed 's/\.log:/\ /g' | cut -d' ' -f1-5 | sort -k3 > roughLogs.txt"
logLocation = '/root/cobaltstrike/logs/'

os.chdir(logLocation)

subprocess.run(query, shell=True)

file = open("roughLogs.txt", "r")
lines = file.read().split("\n")

list = []

for line in lines:
    dash = line.split(' ')
    list.append(dash)
file.close()

subprocess.run('rm roughLogs.txt', shell=True)

interimList = []
count = 0
while count < (len(list) - 1):
    if len(list[count]) < 5:
        count += 1
    else:
        ip = list[count][0]
        beaconPID = list[count][1].split('_')[1]
        month = list[count][2]
        day = list[count][3]
        time = list[count][4]
        date = month + "/" + day
        interimList.append([date,time,ip,beaconPID])
        count +=1

print(''' 
#################################################################################
  Date     Time (UTC)      IP            PID
---------------------------------------------------------------------------------
#################################################################################
''')

for item in interimList:
    print(item)

print('''
''')