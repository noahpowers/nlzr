############################################################################
### Written by Noah Powers                                                 #
###                                                                        #
############################################################################
###                                                                        #
### Returns the status of credentials used during the assessment.          #
###                                                                        #
############################################################################

import os
import subprocess
import time

query = 'grep -r -E -i "pth|make_token|steal_token|dcsync" | grep -E -iv "task|error|binary|note" | grep -E -i "input" > roughLogs.txt'

logLocation = '/root/cobaltstrike/logs'

os.chdir(logLocation)

subprocess.call(query, shell=True)

file = open("roughLogs.txt", "r")
lines = file.read().split("\n")

list = []

for line in lines:
    dash = line.split('/')
    list.append(dash)
file.close()

print(list)

subprocess.call('rm roughLogs.txt', shell=True)

interimList = []
count = 0
while count < (len(list) - 1):
    if len(list[count]) < 2:
        count += 1
    else:
        date = list[count][0]
        IP= list[count][1]
        beaconPID_temp = list[count][2].split('.log:')[0]
        beaconPID = beaconPID_temp.split('_')[1]
        reason = list[count][2].split('.log:')[1]
        command = list[count][3].split('>')[1]
        interimList.append([date,IP,beaconPID,command])
        count += 1
count = 0

print ""
print ''' 
################################################################################
   DTG           IP              BEACON-PID                 METHOD
--------------------------------------------------------------------------------
################################################################################
'''

for item in interimList:
    print item
print '''

'''
