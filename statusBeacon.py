#!/usr/bin/python3
############################################################################
### Written by Noah Powers,                                                #
###                                                                        #
### Designed to be run on the CS Team Server                               #
###                                                                        #
############################################################################
###                                                                        #
### Returns the status of beacons that have phoned home.                   #
###                                                                        #
############################################################################

import os
import subprocess

query = "grep -r -i 'beacon' | grep -i 'initial beacon from ' | grep -E -v -i '(rvauser)' | cut -d':' -f 2-4 | cut -d' ' -f 1,2,7-10 | sort > roughLogs.txt"
query2 = "grep -r -i 'beacon' | grep -i 'initial beacon from ' | grep -E -v -i '(rvauser)' | cut -d':' -f 2-4 | cut -d' ' -f 1,2,7-10 | grep -r -i 'beacon' | grep -i 'initial beacon from ' | grep -E -v -i '(rvauser)' | cut -d' ' -f8-10 | cut -d'@' -f2 | cut -d' ' -f 1 | wc -l"
query3 = "grep -r -i 'beacon' | grep -i 'initial beacon from ' | grep -E -v -i '(rvauser)' | cut -d' ' -f8-10 | sort | uniq | wc -l"

logLocation = '/root/cobaltstrike/logs/'

os.chdir(logLocation)

a = subprocess.run(query2, stdout=subprocess.PIPE, text=True, shell=True)
b = subprocess.run(query3, stdout=subprocess.PIPE, text=True, shell=True)
print('Total Beacons:', (a.stdout).strip('\n'))
print('Total Unique Beacons:', (b.stdout).strip('\n'))
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
    if len(list[count]) > 6:
        count += 1
    elif len(list[count]) == 6:
        date = list[count][0]
        time = list[count][1]
        firstname = list[count][3]
        lastname = list[count][4].split('@')[0]
        ip = list[count][4].split('@')[1]
        computer = list[count][5]
        username = firstname + " " + lastname
        interimList.append([date,time,username,ip,computer])
        count +=1
    elif len(list[count]) == 5:
        date = list[count][0]
        time = list[count][1]
        username = list[count][3].split('@')[0]
        ip = list[count][3].split('@')[1]
        computer = list[count][4]
        interimList.append([date,time,username,ip,computer])
        count +=1
    elif len(list[count]) == 4:
        date = list[count][0]
        time = list[count][1]
        username = list[count][2].split('@')[0]
        ip = list[count][2].split('@')[1]
        computer = list[count][3]
        interimList.append([date,time,username,ip,computer])
        count +=1
    else:
        count += 1

print('''
#################################################################################
  Date     Time (UTC)      Username            IP              Computer
---------------------------------------------------------------------------------
#################################################################################
''')

for item in interimList:
    print(item)

print('''
''')
