#!/bin/bash
## just a one-liner to parse through the results of Mikto (multi-threaded nikto) output files.
## ASSUMPTION is the file names follow the syntax:
##    ipaddr-port.txt
##        e.g.,  192.168.1.1-80.txt
##
## writes a file called 'results.txt' where a semi-useful output with files is found

for y in $(ls)
    do 
    for z in $(grep -E -i "/" $y |grep -E -v "Server:|requests|PROPFIND" | sed -e 's/:\s*/:\ /' | sed -e 's/OSVDB-[0-9]\{3,5\}://' | cut -d" " -f3 | cut -d":" -f1 | grep "\.")
        do echo `echo $y$z` >> text.txt
        done
    done
    
uniq text.txt > results.txt  
sed -i 's/\.txt\//\//' results.txt
sleep 2
sed -i 's/-/:/g' results.txt
sleep 2
sed -i 's/cgi:bin/cgi-bin/g' results.txt
sleep 2
sed -i 's/cgi:local/cgi-local/g' results.txt
rm text.txt
