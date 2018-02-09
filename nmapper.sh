#!/bin/bash

read -p "Enter your firstname (all lowercase letters):  " -r myname
read -p "Enter the name/acronymn of your client [e.g. ACME]:  " -r CLIENT
read -p "Enter the full path and filename for you targets file [e.g. /root/targs.txt]:  " -r targetlist
cp $targetlist ~
cd ~

split -n 10 $targetlist

screen -S nmapr-01 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 1000 -oA $CLIENT-$myname-01-FULL -vvv --open -iL xaa
screen -S nmapr-02 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 1000 -oA $CLIENT-$myname-02-FULL  -vvv --open -iL xab
screen -S nmapr-03 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 1000 -oA $CLIENT-$myname-03-FULL  -vvv --open -iL xac
screen -S nmapr-04 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 1000 -oA $CLIENT-$myname-04-FULL  -vvv --open -iL xad
screen -S nmapr-05 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 1000 -oA $CLIENT-$myname-05-FULL  -vvv --open -iL xae
screen -S nmapr-06 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 1000 -oA $CLIENT-$myname-06-FULL  -vvv --open -iL xaf
screen -S nmapr-07 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 1000 -oA $CLIENT-$myname-07-FULL  -vvv --open -iL xag
screen -S nmapr-08 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 1000 -oA $CLIENT-$myname-08-FULL  -vvv --open -iL xah
screen -S nmapr-09 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 1000 -oA $CLIENT-$myname-09-FULL  -vvv --open -iL xai
screen -S nmapr-10 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 1000 -oA $CLIENT-$myname-10-FULL  -vvv --open -iL xaj

top
