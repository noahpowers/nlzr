#!/bin/bash

function discoveryscan() {
    read -p "Enter your firstname (all lowercase letters):  " -r myname
    read -p "Enter the name/acronymn of your client [e.g. ACME]:  " -r CLIENT
    read -p "Enter the full path and filename for you targets file [e.g. /root/targs.txt]:  " -r targetlist
    cp $targetlist ~
    cd ~

    split -n 10 $targetlist

    screen -S nmapr-01 -d -m nmap -Pn -n -sS -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-01-DISCOVERY -vvv --open -iL xaa
    screen -S nmapr-02 -d -m nmap -Pn -n -sS -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-02-DISCOVERY  -vvv --open -iL xab
    screen -S nmapr-03 -d -m nmap -Pn -n -sS -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-03-DISCOVERY  -vvv --open -iL xac
    screen -S nmapr-04 -d -m nmap -Pn -n -sS -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-04-DISCOVERY  -vvv --open -iL xad
    screen -S nmapr-05 -d -m nmap -Pn -n -sS -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-05-DISCOVERY -vvv --open -iL xae
    screen -S nmapr-06 -d -m nmap -Pn -n -sS -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-06-DISCOVERY  -vvv --open -iL xaf
    screen -S nmapr-07 -d -m nmap -Pn -n -sS -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-07-DISCOVERY  -vvv --open -iL xag
    screen -S nmapr-08 -d -m nmap -Pn -n -sS -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-08-DISCOVERY  -vvv --open -iL xah
    screen -S nmapr-09 -d -m nmap -Pn -n -sS -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-09-DISCOVERY  -vvv --open -iL xai
    screen -S nmapr-10 -d -m nmap -Pn -n -sS -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-10-DISCOVERY  -vvv --open -iL xaj

    top
}

function fullscan() {
    read -p "Enter your firstname (all lowercase letters):  " -r myname
    read -p "Enter the name/acronymn of your client [e.g. ACME]:  " -r CLIENT
    read -p "Enter the full path and filename for you targets file [e.g. /root/targs.txt]:  " -r targetlist
    cp $targetlist ~
    cd ~

    split -n 10 $targetlist

    screen -S nmapr-01 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-01-FULL -vvv --open -iL xaa
    screen -S nmapr-02 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-02-FULL  -vvv --open -iL xab
    screen -S nmapr-03 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-03-FULL  -vvv --open -iL xac
    screen -S nmapr-04 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-04-FULL  -vvv --open -iL xad
    screen -S nmapr-05 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-05-FULL  -vvv --open -iL xae
    screen -S nmapr-06 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-06-FULL  -vvv --open -iL xaf
    screen -S nmapr-07 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-07-FULL  -vvv --open -iL xag
    screen -S nmapr-08 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-08-FULL  -vvv --open -iL xah
    screen -S nmapr-09 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-09-FULL  -vvv --open -iL xai
    screen -S nmapr-10 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-10-FULL  -vvv --open -iL xaj

    top
}


function IDSdiscoveryscan() {
    read -p "Enter your firstname (all lowercase letters):  " -r myname
    read -p "Enter the name/acronymn of your client [e.g. ACME]:  " -r CLIENT
    read -p "Enter the full path and filename for you targets file [e.g. /root/targs.txt]:  " -r targetlist
    cp $targetlist ~
    cd ~
    
    split -n 10 $targetlist
    
    screen -S nmapr-01 -d -m nmap -Pn -n -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-01-DISCOVERY -vvv --open -iL xaa
    screen -S nmapr-02 -d -m nmap -Pn -n -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-02-DISCOVERY  -vvv --open -iL xab
    screen -S nmapr-03 -d -m nmap -Pn -n -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-03-DISCOVERY  -vvv --open -iL xac
    screen -S nmapr-04 -d -m nmap -Pn -n -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-04-DISCOVERY  -vvv --open -iL xad
    screen -S nmapr-05 -d -m nmap -Pn -n -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-05-DISCOVERY -vvv --open -iL xae
    screen -S nmapr-06 -d -m nmap -Pn -n -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-06-DISCOVERY  -vvv --open -iL xaf
    screen -S nmapr-07 -d -m nmap -Pn -n -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-07-DISCOVERY  -vvv --open -iL xag
    screen -S nmapr-08 -d -m nmap -Pn -n -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-08-DISCOVERY  -vvv --open -iL xah
    screen -S nmapr-09 -d -m nmap -Pn -n -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-09-DISCOVERY  -vvv --open -iL xai
    screen -S nmapr-10 -d -m nmap -Pn -n -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-10-DISCOVERY  -vvv --open -iL xaj
    
    top

}

function IDSfullscan() {
    read -p "Enter your firstname (all lowercase letters):  " -r myname
    read -p "Enter the name/acronymn of your client [e.g. ACME]:  " -r CLIENT
    read -p "Enter the full path and filename for you targets file [e.g. /root/targs.txt]:  " -r targetlist
    cp $targetlist ~
    cd ~

    split -n 10 $targetlist

    screen -S nmapr-01 -d -m nmap -Pn -n -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-01-FULL -vvv --open -iL xaa
    screen -S nmapr-02 -d -m nmap -Pn -n -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-02-FULL  -vvv --open -iL xab
    screen -S nmapr-03 -d -m nmap -Pn -n -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-03-FULL  -vvv --open -iL xac
    screen -S nmapr-04 -d -m nmap -Pn -n -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-04-FULL  -vvv --open -iL xad
    screen -S nmapr-05 -d -m nmap -Pn -n -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-05-FULL  -vvv --open -iL xae
    screen -S nmapr-06 -d -m nmap -Pn -n -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-06-FULL  -vvv --open -iL xaf
    screen -S nmapr-07 -d -m nmap -Pn -n -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-07-FULL  -vvv --open -iL xag
    screen -S nmapr-08 -d -m nmap -Pn -n -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-08-FULL  -vvv --open -iL xah
    screen -S nmapr-09 -d -m nmap -Pn -n -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-09-FULL  -vvv --open -iL xai
    screen -S nmapr-10 -d -m nmap -Pn -n -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-10-FULL  -vvv --open -iL xaj

    top
}

PS3="Nmapper Script - Pick an option: "
options=("Discovery Scan" "Full Port Scan" "IDS Evade Discovery Port" "IDS Evade Full Port")
select opt in "${options[@]}" "Quit"; do

    case "$REPLY" in

    #Prep
    1) discoveryscan;;

    2) fullscan;;
    
    3) IDSdiscoveryscan;;
    
    4) IDSfullscan;;

    $(( ${#options[@]}+1 )) ) echo "Thanks for using nmapper!"; break;;
    *) echo "Invalid option. Try another one.";continue;;

    esac

done
