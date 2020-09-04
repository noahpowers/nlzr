#!/bin/bash

function client_zip_structure() {
    echo $'\nMake sure you `su` into the user who owns the share first!\n[ ] if you need to, exit this script and relaunch...\n'
    sleep 2
    read -p "[ ] Customer Shortname:  " -r shortname
    read -p "[ ] Assessment ID and Number:  " -r assessmentID
    path=$( cd ~;pwd )
    cd ~
    rm "share/.Trash*/files/*"
    rm "share/.Trash*/info/*"
    zip -r "${shortname}_${assessmentID}_CLIENT.zip" share/ --exclude "share/Working/*" "share/Documentation/Reports/*" "share/Data/Phishing/Payloads/*" "share/Licenses/*" > /dev/null 2>&1
    echo ""
    echo "Your zip file is stored in the path: ${path}"
    exit
}

function team_zip_structure() {
    echo $'\nMake sure you `su` into the user who owns the share first!\n[ ] if you need to, exit this script and relaunch...\n'
    sleep 2
    read -p "[ ] Customer Shortname:  " -r shortname
    read -p "[ ] Assessment ID and Number:  " -r assessmentID
    asDate=$(date +"%Y%m%d")
    path=$( cd ~;pwd )
    cd ~
    rm "share/.Trash*/files/*"
    rm "share/.Trash*/info/*"
    zip -r "${shortname}_${assessmentID}_${asDate}.zip" share/ > /dev/null 2>&1
    echo ""
    echo "Your zip file is stored in the path: ${path}"
    exit	
}

echo "#######################################"
PS3="zippity, zip that share up! - Pick an option: "
options=("Zip Structure for Client" "Zip Struture for Archiving")
select opt in "${options[@]}" "Quit"; do

    case "$REPLY" in
    #Prep
    1) client_zip_structure;;
    
    2) team_zip_structure;;
    
    $(( ${#options[@]}+1 )) ) echo "L8r"; break;;
    *) echo "Invalid option. Try another one.";continue;;
    
    esac

done
