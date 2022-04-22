#!/usr/bin/python3
############################################################################
### Written by Noah Powers                                                 #
###                                                                        #
############################################################################
###                                                                        #
### Returns the status of uploaded file hashes.                            #
###                                                                        #
############################################################################

import os
import subprocess
from operator import itemgetter

query = 'grep -r "\[indicator\]" | grep -E -iv "service" >> roughLogs.txt'

logLocation = '/root/cobaltstrike/logs/'

os.chdir(logLocation)

subprocess.run(query, shell=True)

os.system("cat roughLogs.txt")
file = open("roughLogs.txt", "r")
lines = file.read().split("\n")

list = []

for line in lines:
    dash = line.split('/')
    list.append(dash)
file.close()

subprocess.run('rm roughLogs.txt', shell=True)

interimList = []
count = 0
while count < (len(list) - 1):
    if len(list[count]) > 15:
        count += 1
    else:
        fromIP = list[count][1]
        fileHash = list[count][3].split(' ')[5]
        temp0 = list[count][3].split(' ')[8]
        location = list[count][3].split(' ')[8]
        substring = "\\"
        if substring in temp0:
            toHost = temp0.split("\\")[2]
            print(toHost)
        else:
            toHost = "N/A"
        if substring in temp0:
            try:
                fileName = temp0.split("\\")[4]
                print(toHost)
            except:
                pass
        else:
            fileName = temp0
        interimList.append([fromIP,toHost,location,fileName,fileHash])
        count += 1
count = 0

## Takes the interimList contents and sorts them; sorted by first element and then second (date/time).
tempList = []
temp = sorted(interimList,key=itemgetter(0,1))

for item in temp:
        if item not in tempList:
            tempList.append(item)
print('')
print('''
#########################################################################################
FROM-IP         To-HOSTNAME        Disk-Location          File-Name          md5-Hash
----------------------------------------------------------------------------------------
#########################################################################################
''')

for item in tempList:
    print(item)
print('''
''')
