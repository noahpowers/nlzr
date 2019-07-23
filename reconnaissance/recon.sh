#!/bin/bash
### Requires sublist3r () be installed along with all dependencies
### git clone https://github.com/aboul3la/Sublist3r ; cd Sublist3r/ ; pip install -r requirements.txt 
### Run script from the Sublist3r folder!!
function install-Sublist3r() {
    echo ""
    dir=$(pwd)
    cd ~
    git clone https://github.com/aboul3la/Sublist3r
    cd Sublist3r/
    pip install -r requirements.txt
    cd $dir
    echo ""
}

function install-SimplyEmail() {
    echo ""
    dir=$(pwd)
    cd ~
    pip install docx2txt pdfminer fake_useragent
    git clone https://github.com/killswitch-GUI/SimplyEmail
    cd SimplyEmail
    bash setup/setup.sh
    cd $dir
    echo ""
}

function gatherDomains() {
    echo ""
    read -p "Enter a domain: " -r name
    dir=$(pwd)
    cd ~
    sublist3rLocation=$(find -name "Sublist3r")
    cd $sublist3rLocation
    test -f ./subdomains.py
    cmd=$(test -f ./subdomains.py)
    cmd2=$(echo $?)
    if [ $cmd2 -eq 1 ]; then
        cd ~
        subdomainFile=$(find -name "subdomains.py")
        cp $subdomainFile $sublist3rLocation 
        cd $sublist3rLocation
    fi
    path2=$(pwd)
    echo "#,Domain Name,IP Address" > ${dir}/${name}-DomainNames.csv
    echo "IPAddress,Number of Names Discovered,Subnet,Organization" > ${dir}/${name}-DomainSubnets.csv
    ipaddr=$(nslookup $name | grep "Address" | grep -iv "#" | cut -d" " -f2)
    count=1
    echo "$count,$name,$ipaddr" >> ${dir}/${name}-DomainNames.csv
    python subdomains.py $name
    mv ${name}_subdomains.txt ${dir}/
    echo "$name" >> ${dir}/${name}_subdomains.txt
    for subname in $(cat ${dir}/${name}_subdomains.txt);
    do
        count=$[count + 1]
        ipaddr=$( nslookup ${subname} | grep "Address" | grep -iv "#" | cut -d" " -f2 | grep -iv ":" )
        ipaddr2=$( echo ${ipaddr} )
        pattern=" |'"
        whois_org=$( whois ${name} | grep "Registrant Organization" | cut -d" " -f3- )
        if [[ $ipaddr2 =~ $pattern ]]; then
            ip1=$(echo ${ipaddr2} | cut -d" " -f1)
            ip2=$(echo ${ipaddr2} | cut -d" " -f2)
            cidr1=$( whois ${ip1} |grep CIDR | cut -d" " -f12 )
            prefix1=$( echo ${cidr1} | cut -d"/" -f2 )
            cidr2=$( whois ${ip2} |grep CIDR | cut -d" " -f12 )
            prefix2=$( echo ${cidr2} | cut -d"/" -f2 )
            echo "$ip1,$subname,$cidr1,$whois_org" >> ${dir}/${name}-DomainSubnets.csv
            echo "$ip2,$subname,$cidr2,$whois_org" >> ${dir}/${name}-DomainSubnets.csv
        else
            cidr=$( whois $ipaddr |grep CIDR | cut -d" " -f12 )
            prefix=$( echo $cidr | cut -d"/" -f2 )
            echo "$ipaddr,$subname,$cidr,$whois_org" >> ${dir}/${name}-DomainSubnets.csv
        fi
        echo "$count,$subname,$ipaddr2" >> ${dir}/${name}-DomainNames.csv
        
    done
    cd ~
    echo $'\n'
    echo "File stored in directory: ${dir} "
    echo $'\n'
    cd $dir
}

function findEmails() {
    echo ""
    read -p "Enter Path to File Containing Domains [full path]: " -r targetsfile
    pip install BeautifulSoup
    dir=$(pwd)
    cd ~
    cd ~/SimplyEmail
    for z in $(cat $targetsfile);
        do 
        python SimplyEmail.py -e ${z} -all --json ${z}-emails.txt
    done
    echo "[+] Email files stored in path: ${path} "
    cp -a *-emails.txt $dir
    rm *-emails.txt
    cd $dir
    echo ""
}

function webappHosting() {
    echo ""    
    apt-get install -qq -y jq
    echo ""
    path=$(pwd)
    read -p $'Enter the name of your parent domain (e.g., google.com):  \n' -r parentname
    read -p $'Enter full path file location for domain file (e.g., /root/domains.txt):  \n' -r domains
    cmd=$(test -f ./${parentname}_domain-ownership.txt)
    cmd2=$(echo $?)
    if [ $cmd2 -eq 0 ]; then
        rm ${parentname}_domain-ownership.txt
    fi
    for z in $(cat ${domains}); do
        echo $'\n###########################\n' >> ${parentname}_domain-ownership.txt
        whois $z | grep -iv "No match for" | grep -E "Domain\ Name|Registrar:|Registrant\ Organization|Registrant\ Admin|Tech\ Organization|Name\ Server" >> ${parentname}_domain-ownership.txt
        nslookup $z | grep -E -iv "server|#|non-authoritative" >> ${parentname}_domain-ownership.txt
        y=$( nslookup ${z} | grep -E -iv "server|#|non-authoritative|name" | cut -d" " -f2 )
        x=$(echo ${y} | cut -d" " -f2 )
        curl ipinfo.io/$x | jq '.ip,.org,.hostname,.city,.region' >> ${parentname}_domain-ownership.txt
    done
    sed -i 's/\ \ \ //g' ${parentname}_domain-ownership.txt
    echo $'\nWeb App domain hosting information is stored in domain-ownership.txt\n'
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
