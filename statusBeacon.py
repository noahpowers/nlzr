############################################################################
### Written by Noah Powers, Delta Risk (LLC)                               #
###                                                                        #
### Designed to be run on the CS Team Server                               #
### Tested in a limited set of logs (one week worth) with CS version 3.3   #
############################################################################
###                                                                        #
### Returns the status of beacons that have phoned home.                   #
###                                                                        #
############################################################################

import os
import subprocess

query = "grep -r -i 'beacon' | grep -i 'initial beacon from ' | grep -E -v -i '(rvauser)' | cut -d' ' -f7,8 | cut -d' ' -f1,2,7-11 | sort > roughLogs.txt"
query2 = "grep -r -i 'beacon' | grep -i 'initial beacon from ' | grep -E -v -i '(rvauser)' | cut -d' ' -f7,8 | cut -d'@' -f2 | cut -d' ' -f1 | wc -l"
query3 = "grep -r -i 'beacon' | grep -i 'initial beacon from ' | grep -E -v -i '(rvauser)' | cut -d' ' -f7,8 | cut -d'@' -f2 | cut -d' ' -f1 | sort | uniq | wc -l"

print ""
print 'Total Beacons: '
subprocess.call(query2, shell=True)
print 'Total Unique Beacons: '
subprocess.call(query3, shell=True)

logLocation = '/root/cobaltstrike/logs/'

os.chdir(logLocation)

subprocess.call(query, shell=True)


file = open("roughLogs.txt", "r")
lines = file.read().split("\n")

list = []

for line in lines:
    dash = line.split(' ')
    list.append(dash)
file.close()

subprocess.call('rm roughLogs.txt', shell=True)

interimList = []
count = 0
while count < (len(list) - 1):
    if len(list[count]) > 5:
        count += 1
    elif len(list[count]) == 5:
        date = list[count][0]
        time = list[count][1]
        firstname = list[count][2]
        lastname = list[count][3].split('@')[0]
        ip = list[count][3].split('@')[1]
        computer = list[count][4]
        username = firstname + " " + lastname
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

print ''' 
#################################################################################
  Date     Time      Username            IP              Computer
---------------------------------------------------------------------------------
#################################################################################
'''

for item in interimList:
    print item

print '''

'''
