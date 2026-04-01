#!/bin/bash

#Check to see if we are running with root privileges
if [[ $EUID -ne 0 ]]; then
    echo "Please run this script as root" 1>&2
    exit 1
fi

function discoveryscan-regular() {
    read -p "Enter your firstname (all lowercase letters):  " -r myname
    read -p "Enter the name/acronymn of your client [e.g. ACME]:  " -r CLIENT
    read -p "Enter the full path and filename for you targets file [e.g. /root/targs.txt]:  " -i "" -e targetlist
    read -p "Enter the output directory [e.g. /root/]:  " -i "" -e outputdir
    mkdir -p $outputdir
    cp $targetlist $outputdir
    cd $outputdir

    split -n l/10 $targetlist

    screen -S nmapr-01 -d -m nmap -Pn -n -sS -p 21-23,25,53,137,139,389,445,636,80,88,443,515,631,3268,3269,8443,8080,9100 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-01-DISCOVERY -vvv --open -iL xaa
    screen -S nmapr-02 -d -m nmap -Pn -n -sS -p 21-23,25,53,137,139,389,445,636,80,88,443,515,631,3268,3269,8443,8080,9100 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-02-DISCOVERY  -vvv --open -iL xab
    screen -S nmapr-03 -d -m nmap -Pn -n -sS -p 21-23,25,53,137,139,389,445,636,80,88,443,515,631,3268,3269,8443,8080,9100 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-03-DISCOVERY  -vvv --open -iL xac
    screen -S nmapr-04 -d -m nmap -Pn -n -sS -p 21-23,25,53,137,139,389,445,636,80,88,443,515,631,3268,3269,8443,8080,9100 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-04-DISCOVERY  -vvv --open -iL xad
    screen -S nmapr-05 -d -m nmap -Pn -n -sS -p 21-23,25,53,137,139,389,445,636,80,88,443,515,631,3268,3269,8443,8080,9100 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-05-DISCOVERY -vvv --open -iL xae
    screen -S nmapr-06 -d -m nmap -Pn -n -sS -p 21-23,25,53,137,139,389,445,636,80,88,443,515,631,3268,3269,8443,8080,9100 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 620 -oA $CLIENT-$myname-06-DISCOVERY  -vvv --open -iL xaf
    screen -S nmapr-07 -d -m nmap -Pn -n -sS -p 21-23,25,53,137,139,389,445,636,80,88,443,515,631,3268,3269,8443,8080,9100 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-07-DISCOVERY  -vvv --open -iL xag
    screen -S nmapr-08 -d -m nmap -Pn -n -sS -p 21-23,25,53,137,139,389,445,636,80,88,443,515,631,3268,3269,8443,8080,9100 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-08-DISCOVERY  -vvv --open -iL xah
    screen -S nmapr-09 -d -m nmap -Pn -n -sS -p 21-23,25,53,137,139,389,445,636,80,88,443,515,631,3268,3269,8443,8080,9100 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-09-DISCOVERY  -vvv --open -iL xai
    screen -S nmapr-10 -d -m nmap -Pn -n -sS -p 21-23,25,53,137,139,389,445,636,80,88,443,515,631,3268,3269,8443,8080,9100 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-10-DISCOVERY  -vvv --open -iL xaj
    top
}

function discoveryscan-large() {
    read -p "Enter your firstname (all lowercase letters):  " -r myname
    read -p "Enter the name/acronymn of your client [e.g. ACME]:  " -r CLIENT
    read -p "Enter the full path and filename for you targets file [e.g. /root/targs.txt]:  " -i "" -e targetlist
    read -p "Enter the output directory [e.g. /root/]:  " -i "" -e outputdir
    mkdir -p $outputdir
    cp $targetlist $outputdir
    cd $outputdir

    split -n l/10 --numeric-suffixes=01 $targetlist file

    counter=1
    while [ "$counter" -le 10 ]; do
        file_num=$(printf "%02d" "$counter")
        currentFile="file${file_num}"

        if [ ! -f "$currentFile" ]; then
            echo "Warning: $currentFile not found, skipping."
            ((counter++))
            continue
        fi

        while true; do
            if screen -ls 2>/dev/null | grep -q "No Sockets"; then
                echo "No screen sessions detected. Processing $currentFile..."
                break
            else
                echo "Screen sessions still active. Waiting 10 minutes..."
                sleep 600
            fi
        done

        rm -f xa[a-j]

        split -n l/10 $currentFile

        screen -S nmapr-01 -d -m nmap -Pn -n -sS -p 21-23,25,53,137,139,389,445,636,80,88,443,515,631,1433,3268,3269,3306,8443,8080,9100 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$currentFile-$myname-01-DISCOVERY -vvv --open -iL xaa
        screen -S nmapr-02 -d -m nmap -Pn -n -sS -p 21-23,25,53,137,139,389,445,636,80,88,443,515,631,3268,3269,8443,8080,9100 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$currentFile-$myname-02-DISCOVERY  -vvv --open -iL xab
        screen -S nmapr-03 -d -m nmap -Pn -n -sS -p 21-23,25,53,137,139,389,445,636,80,88,443,515,631,3268,3269,8443,8080,9100 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$currentFile-$myname-03-DISCOVERY  -vvv --open -iL xac
        screen -S nmapr-04 -d -m nmap -Pn -n -sS -p 21-23,25,53,137,139,389,445,636,80,88,443,515,631,3268,3269,8443,8080,9100 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$currentFile-$myname-04-DISCOVERY  -vvv --open -iL xad
        screen -S nmapr-05 -d -m nmap -Pn -n -sS -p 21-23,25,53,137,139,389,445,636,80,88,443,515,631,3268,3269,8443,8080,9100 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$currentFile-$myname-05-DISCOVERY -vvv --open -iL xae
        screen -S nmapr-06 -d -m nmap -Pn -n -sS -p 21-23,25,53,137,139,389,445,636,80,88,443,515,631,3268,3269,8443,8080,9100 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$currentFile-$myname-06-DISCOVERY  -vvv --open -iL xaf
        screen -S nmapr-07 -d -m nmap -Pn -n -sS -p 21-23,25,53,137,139,389,445,636,80,88,443,515,631,3268,3269,8443,8080,9100 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$currentFile-$myname-07-DISCOVERY  -vvv --open -iL xag
        screen -S nmapr-08 -d -m nmap -Pn -n -sS -p 21-23,25,53,137,139,389,445,636,80,88,443,515,631,3268,3269,8443,8080,9100 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$currentFile-$myname-08-DISCOVERY  -vvv --open -iL xah
        screen -S nmapr-09 -d -m nmap -Pn -n -sS -p 21-23,25,53,137,139,389,445,636,80,88,443,515,631,3268,3269,8443,8080,9100 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$currentFile-$myname-09-DISCOVERY  -vvv --open -iL xai
        screen -S nmapr-10 -d -m nmap -Pn -n -sS -p 21-23,25,53,137,139,389,445,636,80,88,443,515,631,3268,3269,8443,8080,9100 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$currentFile-$myname-10-DISCOVERY  -vvv --open -iL xaj
        ((counter++))
        echo "[+] Started scanning:  $currentFile"
    done
    echo "[+] All Files Processed"
}

function fullscan() {
    read -p "Enter your firstname (all lowercase letters):  " -r myname
    read -p "Enter the name/acronymn of your client [e.g. ACME]:  " -r CLIENT
    read -p "Enter the full path and filename for you targets file [e.g. /root/targs.txt]:  " -i "" -e targetlist
    read -p "Enter the output directory [e.g. /root/]:  " -i "" -e outputdir
    mkdir -p $outputdir
    cp $targetlist $outputdir
    cd $outputdir

    split -n l/10 $targetlist

    screen -S nmapr-01 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-01-FULL -vvv --open -iL xaa
    screen -S nmapr-02 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-02-FULL  -vvv --open -iL xab
    screen -S nmapr-03 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-03-FULL  -vvv --open -iL xac
    screen -S nmapr-04 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-04-FULL  -vvv --open -iL xad
    screen -S nmapr-05 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-05-FULL  -vvv --open -iL xae
    screen -S nmapr-06 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-06-FULL  -vvv --open -iL xaf
    screen -S nmapr-07 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-07-FULL  -vvv --open -iL xag
    screen -S nmapr-08 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-08-FULL  -vvv --open -iL xah
    screen -S nmapr-09 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-09-FULL  -vvv --open -iL xai
    screen -S nmapr-10 -d -m nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-10-FULL  -vvv --open -iL xaj

    top
}


function IDSdiscoveryscan() {
    read -p "Enter your firstname (all lowercase letters):  " -r myname
    read -p "Enter the name/acronymn of your client [e.g. ACME]:  " -r CLIENT
    read -p "Enter the full path and filename for you targets file [e.g. /root/targs.txt]:  " -i "" -e targetlist
    cp $targetlist ~
    cd ~
    
    split -n l/10 $targetlist
    
    screen -S nmapr-01 -d -m nmap -Pn -n -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-01-DISCOVERY -vvv --open -iL xaa
    screen -S nmapr-02 -d -m nmap -Pn -n -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-02-DISCOVERY  -vvv --open -iL xab
    screen -S nmapr-03 -d -m nmap -Pn -n -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-03-DISCOVERY  -vvv --open -iL xac
    screen -S nmapr-04 -d -m nmap -Pn -n -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-04-DISCOVERY  -vvv --open -iL xad
    screen -S nmapr-05 -d -m nmap -Pn -n -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-05-DISCOVERY -vvv --open -iL xae
    screen -S nmapr-06 -d -m nmap -Pn -n -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-06-DISCOVERY  -vvv --open -iL xaf
    screen -S nmapr-07 -d -m nmap -Pn -n -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-07-DISCOVERY  -vvv --open -iL xag
    screen -S nmapr-08 -d -m nmap -Pn -n -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-08-DISCOVERY  -vvv --open -iL xah
    screen -S nmapr-09 -d -m nmap -Pn -n -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-09-DISCOVERY  -vvv --open -iL xai
    screen -S nmapr-10 -d -m nmap -Pn -n -p 21-23,25,53,111,137,139,445,80,443,8443,8080 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-10-DISCOVERY  -vvv --open -iL xaj
    
    top

}

function IDSfullscan() {
    read -p "Enter your firstname (all lowercase letters):  " -r myname
    read -p "Enter the name/acronymn of your client [e.g. ACME]:  " -r CLIENT
    read -p "Enter the full path and filename for you targets file [e.g. /root/targs.txt]:  " -i "" -e targetlist
    cp $targetlist ~
    cd ~

    split -n l/10 $targetlist

    screen -S nmapr-01 -d -m nmap -Pn -n -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-01-FULL -vvv --open -iL xaa
    screen -S nmapr-02 -d -m nmap -Pn -n -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-02-FULL  -vvv --open -iL xab
    screen -S nmapr-03 -d -m nmap -Pn -n -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-03-FULL  -vvv --open -iL xac
    screen -S nmapr-04 -d -m nmap -Pn -n -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-04-FULL  -vvv --open -iL xad
    screen -S nmapr-05 -d -m nmap -Pn -n -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-05-FULL  -vvv --open -iL xae
    screen -S nmapr-06 -d -m nmap -Pn -n -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-06-FULL  -vvv --open -iL xaf
    screen -S nmapr-07 -d -m nmap -Pn -n -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-07-FULL  -vvv --open -iL xag
    screen -S nmapr-08 -d -m nmap -Pn -n -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-08-FULL  -vvv --open -iL xah
    screen -S nmapr-09 -d -m nmap -Pn -n -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-09-FULL  -vvv --open -iL xai
    screen -S nmapr-10 -d -m nmap -Pn -n -p- --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 500 -oA $CLIENT-$myname-10-FULL  -vvv --open -iL xaj

    top
}

function udpscan() {
    read -p "Enter your firstname (all lowercase letters):  " -r myname
    read -p "Enter the name/acronymn of your client [e.g. ACME]:  " -r CLIENT
    read -p "Enter the full path and filename for you targets file [e.g. /root/targs.txt]:  " -i "" -e targetlist
    cp $targetlist ~
    cd ~

    split -n l/10 $targetlist

    screen -S nmapr-01 -d -m nmap -Pn -sU -p 1-1000,5353,1900 --oA $CLIENT-$myname-01-UDP  -vvv -iL xaa
    screen -S nmapr-02 -d -m nmap -Pn -sU -p 1-1000,5353,1900 --oA $CLIENT-$myname-02-UDP  -vvv -iL xab
    screen -S nmapr-03 -d -m nmap -Pn -sU -p 1-1000,5353,1900 --oA $CLIENT-$myname-03-UDP  -vvv -iL xac
    screen -S nmapr-04 -d -m nmap -Pn -sU -p 1-1000,5353,1900 --oA $CLIENT-$myname-04-UDP  -vvv -iL xad
    screen -S nmapr-05 -d -m nmap -Pn -sU -p 1-1000,5353,1900 --oA $CLIENT-$myname-05-UDP  -vvv -iL xae
    screen -S nmapr-06 -d -m nmap -Pn -sU -p 1-1000,5353,1900 --oA $CLIENT-$myname-06-UDP  -vvv -iL xaf
    screen -S nmapr-07 -d -m nmap -Pn -sU -p 1-1000,5353,1900 --oA $CLIENT-$myname-07-UDP  -vvv -iL xag
    screen -S nmapr-08 -d -m nmap -Pn -sU -p 1-1000,5353,1900 --oA $CLIENT-$myname-08-UDP  -vvv -iL xah
    screen -S nmapr-09 -d -m nmap -Pn -sU -p 1-1000,5353,1900 --oA $CLIENT-$myname-09-UDP  -vvv -iL xai
    screen -S nmapr-10 -d -m nmap -Pn -sU -p 1-1000,5353,1900 --oA $CLIENT-$myname-10-UDP  -vvv -iL xaj

    top
}

PS3="Nmapper Script - Pick an option: "
options=("Discovery Scan (regular)" "Discovery Scan (large)" "Full Port Scan" "IDS Evade Discovery Port" "IDS Evade Full Port" "UDP Scan")
select opt in "${options[@]}" "Quit"; do

    case "$REPLY" in

    #Prep
    1) discoveryscan-regular;;

    2) discoveryscan-large;; 

    3) fullscan;;
    
    4) IDSdiscoveryscan;;
    
    5) IDSfullscan;;

    6) udpscan;;

    $(( ${#options[@]}+1 )) ) echo "Thanks for using nmapper!"; break;;
    *) echo "Invalid option. Try another one.";continue;;

    esac

done
