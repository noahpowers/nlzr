import re
import subprocess

ipList = []

count = 0
while count <= <number>:
	ipAddr = ipList[count]
	p = subprocess.Popen(["ping","-c 1",ipAddr], stdout = subprocess.PIPE)
	s = p.communicate()[0]
	pingback = re.compile('(.*)ttl=12(.*)\n')
	matchResult = pingback.search(s)
	if matchResult:
		fh = open("windows-445hosts.txt","a")
		fh.write(ipList[count] + "\n")
		fh.close
		print(ipList[count])

	count += 1
