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
from operator import itemgetter

query = 'grep -r -E -i "pth|make_token|steal_token|dcsync|spawnas|runas" | grep -E -iv "task|error|binary|note" | grep -E -i "input" > roughLogs.txt'

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

subprocess.call('rm roughLogs.txt', shell=True)

interimList = []
count = 0
while count < (len(list) - 1):
    if len(list[count]) < 2:
        count += 1
    else:
## This if/else statement is required to get around how some log entries contain an additional ':' that we must get rid of
        if ":" in list[count][0]:
            date  = list[count][0].split(':')[1]
        else:
            date = list[count][0]
        IP= list[count][1]
        beaconPID_temp = list[count][2].split('.log:')[0]
        beaconPID = beaconPID_temp.split('_')[1]
        reason = list[count][2].split('.log:')[1]
        btime = list[count][3].split(' ')[1]
        operator_t0 = list[count][3].split(' ')[4]
        operator_t1 = operator_t0.split('<')[1]
        operator = operator_t1.split('>')[0]
        command = list[count][3].split('>')[1]
        if "make_token" in command:
            command = command[:-3]
            command_1 = command.split(' ')[1]
            command_2 = command.split(' ')[2]
            command_3 = command.split(' ')[-1][:2] + "#" * 12
            command = command_1 + " " + command_2 + " " + command_3
        else:
            command = command
        if "pth" in command:
            command = command[:-3]
            command_1 = command.split(' ')[1]
            command_2 = command.split(' ')[2]
            command_3 = command.split(' ')[-1][:2] + "#" * 12
            command = command_1 + " " + command_2 + " " + command_3
        else:
            command = command
        interimList.append([date,btime,IP,beaconPID,command,operator])
        count += 1
count = 0

## Takes the interimList contents and sorts them; sorted by first element and then second (date/time).
tempList = []
temp = sorted(interimList,key=itemgetter(0,1))

for item in temp: 
        if item not in tempList: 
            tempList.append(item)

print ""
print ''' 
###################################################################################################
   DATE       TIME           IP          BEACON-PID           METHOD                OPERATOR
--------------------------------------------------------------------------------------------------
###################################################################################################
'''

for item in tempList:
    print item
print '''

'''
