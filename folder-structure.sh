#!/bin/bash

function create_structure() {
    echo $'\nONLY RUN THIS OPTION IF YOU WERE INSTRUCTED TO...\n\tThis option most likely does not apply to your situation!..!\n\t\tThe other options may still be helpful\n\n'
    sleep 2
    cd ~
    mkdir -p "share/Archive"
    mkdir -p "share/Data/Database"
    mkdir -p "share/Data/Network Mapping/Internal/DomainFlyOver/"
    mkdir -p "share/Data/Network Mapping/Internal/Nmap/"
    mkdir -p "share/Data/Network Mapping/External/Nmap/"
    mkdir -p "share/Data/Network Mapping/External/DomainFlyOver/"
    mkdir -p "share/Data/Network Mapping/External/OSINT/"
    mkdir -p "share/Data/Penetration Test/Cobalt Strike/"
    mkdir -p "share/Data/Vulnerability Scanning/External/Nessus/"
    mkdir -p "share/Data/Vulnerability Scanning/External/Nuclei/"
    mkdir -p "share/Data/Vulnerability Scanning/Internal/Nessus/"
    mkdir -p "share/Data/Vulnerability Scanning/Internal/Nuclei/"
    mkdir -p "share/Data/Web App/BurpSuite/"
    mkdir -p "share/Data/Web App/Gowitness/"
    mkdir -p "share/Data/Phishing/Targets/"
    mkdir -p "share/Data/Phishing/Templates/"
    mkdir -p "share/Data/Phishing/Payloads/"
    mkdir -p "share/Data/Wireless/"
    mkdir -p "share/Working/scope/external"
    mkdir -p "share/Working/scope/internal"
    mkdir -p "share/Working/loot"
    mkdir -p "share/Documentation/Reports/"
}

function client_zip_structure() {
# we use p7zip to ensure all customers can open the file ("legacy support")
    echo $'\nMake sure you `su` into the user who owns the share first!\n[ ] if you need to, exit this script and relaunch...'
    sleep 2
    read -p "[ ] Assessment ID and Number:  " -r assessmentID
    read -p "[ ] Customer Shortname:  " -r shortname
    path=$( cd ~;pwd )
    cd ~
    sudo apt install -q -y p7zip-full
    rm "share/.Trash*/files/*"
    rm "share/.Trash*/info/*"
     7z a -tzip -p -mem=ZipCrypto "${assessmentID}-${shortname}-CLIENT.zip" share/Data/ > /dev/null 2>&1
    echo "Your zip file is stored in the path: ${path}"
    exit
}

function team_zip_structure() {
# we use p7zip to ensure all customers can open the file ("legacy support")
    echo $'\nMake sure you `su` into the user who owns the share first!\n[ ] if you need to, exit this script and relaunch...\n'
    sleep 2
    read -p "[ ] Assessment ID and Number:  " -r assessmentID
    read -p "[ ] Customer Shortname:  " -r shortname
    asDate=$(date +"%Y%m%d")
    path=$( cd ~;pwd )
    sudo apt install -q -y p7zip-full
    cd ~
    rm "share/.Trash*/files/*"
    rm "share/.Trash*/info/*"
    7z a -tzip -p -mem=ZipCrypto "${assessmentID}_${shortname}_${asDate}.zip" share/ > /dev/null 2>&1
    echo "Your zip file is stored in the path: ${path}"
    exit	
}

echo "#######################################"
PS3="Server Setup Script - Pick an option: "
options=("Create Structure" "Zip Structure for Client" "Zip Struture for Archiving")
select opt in "${options[@]}" "Quit"; do

    case "$REPLY" in
    #Prep
    1) create_structure;;
    
    2) client_zip_structure;;
    
    3) team_zip_structure;;
    
    $(( ${#options[@]}+1 )) ) echo "L8r"; break;;
    *) echo "Invalid option. Try another one.";continue;;
    
    esac

done
