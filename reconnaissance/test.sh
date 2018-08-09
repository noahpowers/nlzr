#!/bin/bash
### Requires sublist3r () be installed along with all dependencies
### git clone https://github.com/aboul3la/Sublist3r ; cd Sublist3r/ ; pip install -r requirements.txt 
### Run script from the Sublist3r folder!!
function install-Sublist3r() {
    git clone https://github.com/aboul3la/Sublist3r
    cd Sublist3r/
    pip install -r requirements.txt
    cd ..

}

function install-SimplyEmail() {
    git clone https://github.com/killswitch-GUI/SimplyEmail
    cd SimplyEmail
    bash setup/setup.sh
}

function gatherDomains() {
    read -p "Enter a domain: " -r name
    cp subdomains.py Sublist3r/
    cd Sublist3r/
    echo "#,Domain Name,IP Address" > ${name}-DomainNames.csv
    echo "Subnet,Number of Names Discovered,Min IP,Max IP" > ${name}-DomainSubnets.csv
    ipaddr=$(nslookup $name | grep "Address" | grep -iv "#" | cut -d" " -f2)
    count=1
    echo "$count,$name,$ipaddr" >> ${name}-DomainNames.csv

    python subdomains.py $name
    echo "$name" >> ${name}_subdomains.txt

    for subname in $(cat ${name}_subdomains.txt);
    do
        count=$[count + 1]
        ipaddr=$(nslookup $subname | grep "Address" | grep -iv "#" | cut -d" " -f2)
        cidr=$(whois $ipaddr |grep CIDR | cut -d" " -f12)
        prefix=$(echo $cidr | cut -d"/" -f2)
        echo "$count,$subname,$ipaddr" >> ${name}-DomainNames.csv
        echo "$cidr,$subname,," >> ${name}-DomainSubnets.csv
    done
    cd ..
}

function findEmails() {
    domainfile="/root/*_subdomains.txt.txt"
    read -p "Enter Path to File Containing Domains [full path]: " -r targetsfile
    cd SimplyEmail/
    for z in $(cat $targetsfile);
    path=$(pwd)
    do 
        python SimplyEmail.py -e $z -all --json ${z}-emails.txt
    done
    echo "[+] Email files stored in path: ${path}"
    cd ..
}

PS3="Server Setup Script - Pick an option: "
options=("Install Sublist3r" "Install SimplyEmail" "Find Sub-Domains" "Find Emails")
select opt in "${options[@]}" "Quit"; do

    case "$REPLY" in

    #Prep
    1) install-Sublist3r;;

    2) install-SimplyEmail;;

    3) gatherDomains;;

    4) findEmails;;

    $(( ${#options[@]}+1 )) ) echo "Goodbye!"; break;;
    *) echo "Invalid option. Try another one.";continue;;

    esac

done
