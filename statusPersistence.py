############################################################################
### Written by Noah Powers, Delta Risk (LLC)                               #
###                                                                        #
### Designed to be run on the CS Team Server                               #
### Tested in a limited set of logs (one week worth) with CS version 3.3   #
############################################################################
###                                                                        #
### Returns the status of persistence conducted.  Dates ordered old -> new.#
### Very possible, for the same IP to have many entries...                 #
### One for creation, another for deletion, and maybe others for diff PIDs.#
###                                                                        #
############################################################################

import os
import subprocess

query = 'grep -r -i "persist" | grep -v "persistent=" | grep -v ".xml" | grep -v "Tasked beacon to " | grep -v "CsPersistentChatAdministrator" | grep -v "powershell-import" | grep -v "Install-" | grep -v "Remove-" >> roughLogs.txt'

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
    if len(list[count]) > 3:
        count += 1
    else:
        date = list[count][0]
        ip = list[count][1]
        pid = list[count][2].split('.log:')[0]
        reason = list[count][2].split('.log:')[1]
        interimList.append([date,ip,pid,reason])
        count +=1

print ""
print ''' 
################################################################################
   DTG           IP              PID                Persistence Status
--------------------------------------------------------------------------------
################################################################################
'''

for item in interimList:
    print item
