#!/bin/bash
### Requires sublist3r () be installed along with all dependencies
### git clone https://github.com/aboul3la/Sublist3r ; cd Sublist3r/ ; pip install -r requirements.txt 
### Run script from the Sublist3r folder!!
function install-Sublist3r() {
    dir=$(pwd)
    cd ~
    git clone https://github.com/aboul3la/Sublist3r
    cd Sublist3r/
    pip install -r requirements.txt
    cd $dir
}

function install-SimplyEmail() {
    dir=$(pwd)
    cd ~
    git clone https://github.com/killswitch-GUI/SimplyEmail
    cd SimplyEmail
    bash setup/setup.sh
    cd $dir
}

function gatherDomains() {
    read -p "Enter a domain: " -r name
    dir=$(pwd)
    cd ~
    subdomainFile=$(find -name "subdomains.py")
    sublist3rLocation=$(find -name "Sublist3r")
    cp $subdomainFile $sublist3rLocation 
    cd $sublist3rLocation
    path2 = $(pwd)
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
        ipaddr=$( nslookup $subname | grep "Address" | grep -iv "#" | cut -d" " -f2 )
        cidr=$( whois $ipaddr |grep CIDR | cut -d" " -f12 )
        prefix=$( echo $cidr | cut -d"/" -f2 )
        echo "$count,$subname,$ipaddr" >> ${name}-DomainNames.csv
        echo "$cidr,$subname,," >> ${name}-DomainSubnets.csv
    done
    cd ~
    sublist3rLocation=$(find -name "Sublist3r")
    echo $'\n'
    echo "File stored in directory: ${path2} "
    echo $'\n'
    cd $dir
}

function findEmails() {
    #domainfile="/root/*_subdomains.txt.txt"
    read -p "Enter Path to File Containing Domains [full path]: " -r targetsfile
    pip install BeautifulSoup
    dir=$(pwd)
    cd ~
    #path=$(find -name SimplyEmail)
    #cd $path
    cd ~/SimplyEmail
    for z in $(cat $targetsfile);
        do 
        python SimplyEmail.py -e ${z} -all --json ${z}-emails.txt
    done
    echo "[+] Email files stored in path: ${path} "
    cp -a *-emails.txt $dir
    rm *-emails.txt
    cd $dir
}

function webappHosting() {
    rm domain-ownership.txt
    apt-get install -qq -y jq
    path=$(pwd)
    read -p $'Enter full path file location for domain file (e.g., /root/domains.txt):  \n' -r domains
    for z in $(cat ${domains});
        do 
            echo $'\n###########################\n' >> domain-ownership.txt
            whois $z |grep -E "Domain\ Name|Registrar:|Registrant\ Organization|Registrant\ Admin|Tech\ Organization|Name\ Server" >> domain-ownership.txt
            nslookup $z | grep -E -iv "192.168.202|non-authoritative" >> domain-ownership.txt
            y=$( nslookup ${z} | grep -E -iv "192.168.202|name" | cut -d" " -f2 )
            x=$(echo ${y} | cut -d" " -f2 )
            curl ipinfo.io/$x | jq '.ip,.org,.hostname,.city,.region' >> domain-ownership.txt
    done
    sed -i 's/\ \ \ //g' domain-ownership.txt
    echo $'\nWeb App domain hosting information is stored in "${path}/domain-ownership.txt"\n'
}

PS3="recon - Pick an option: "
options=("Install Sublist3r" "Install SimplyEmail" "Find Sub-Domains" "Find Emails" "Find WebApp Host")
select opt in "${options[@]}" "Quit"; do

    case "$REPLY" in

    #Prep
    1) install-Sublist3r;;

    2) install-SimplyEmail;;

    3) gatherDomains;;

    4) findEmails;;
    
    5) webappHosting;;

    $(( ${#options[@]}+1 )) ) echo "Goodbye!"; break;;
    *) echo "Invalid option. Try another one.";continue;;

    esac
done
