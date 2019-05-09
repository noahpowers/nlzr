############################################################################
### Written by Noah Powers                                                 #
###                                                                        #
############################################################################
###                                                                        #
### Returns the status of persistence conducted.  Dates ordered old -> new.#
### Very possible, for the same IP to have many entries...                 #
### One for creation, another for deletion, and maybe others for diff PIDs.#
###                                                                        #
############################################################################

import os
import subprocess
import time

query = 'grep -r -E -i "psexec|psexec_psh|wmi" | grep -E -iv "WmiPrvSE|servicename|path|abusefunction|get" | grep -i "input" >> roughLogs.txt'

logLocation = '/mnt/share/Working/CobaltStrike/External/RawData/logs'

os.chdir(logLocation)

subprocess.call(query, shell=True)

file = open("roughLogs.txt", "r")
lines = file.read().split("\n")

list = []

for line in lines:
    dash = line.split('/')
    list.append(dash)
file.close()

subprocess.call('rm roughLogs.txt', shell=True)

interimList = []
count = 0
while count < (len(list) - 1):
    if len(list[count]) > 4:
        count += 1
    else:
        date = list[count][0]
        fromIP= list[count][1]
        spawnPID_temp = list[count][2].split('.log:')[0]
        spawnPID = spawnPID_temp.split('_')[1]
        reason = list[count][2].split('.log:')[1]
        command = list[count][3].split('> ')[1]
        interimList.append([date,spawnPID,fromIP,command])
        count += 1
count = 0

print ""
print '''
Beacons:
'''
print 
print ''' 
################################################################################
   DTG           Spawn-PID              FROM-IP                 To-HOSTNAME
--------------------------------------------------------------------------------
################################################################################
'''

for item in interimList:
    print item
print '''

'''
