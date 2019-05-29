############################################################################
### Written by Noah Powers                                                 #
###                                                                        #
############################################################################
###                                                                        #
### Returns the status of lateral movement methods.                        #
###                                                                        #
############################################################################

import os
import subprocess
import time

query = 'grep -r -E -i "psexec|psexec_psh|wmi" | grep -E -iv "WmiPrvSE|servicename|path|abusefunction|get" | grep -i "input" >> roughLogs.txt'

logLocation = '/root/cobaltstrike/logs/'

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
        btime = list[count][3].split(' ')[1]
        reason = list[count][2].split('.log:')[1]
        operator_t0 = list[count][3].split(' ')[4]
        operator_t1 = operator_t0.split('<')[1]
        operator = operator_t1.split('>')[0]
        command = list[count][3].split('> ')[1]
        interimList.append([date,btime,spawnPID,fromIP,command,operator])
        count += 1
count = 0

print ""
print ''' 
#########################################################################################
   DATE     TIME       Spawn-PID     FROM-IP            To-HOSTNAME          OPERATOR
----------------------------------------------------------------------------------------
#########################################################################################
'''

for item in interimList:
    print item
print '''

'''
