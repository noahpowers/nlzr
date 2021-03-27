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
    python -m pip install certifi
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
    sed -i 's/<BR>/\n/g' ${dir}/${name}_subdomains.txt
    cat ${dir}/${name}_subdomains.txt | uniq >> raw000.txt
    cat raw000.txt > ${dir}/${name}_subdomains.txt
    rm raw000.txt
    for subname in $(cat ${dir}/${name}_subdomains.txt);
    do
        count=$[count + 1]
        ipaddr=$( nslookup ${subname} | grep "Address" | grep -iv "#" | cut -d" " -f2 | grep -iv ":" )
        ipaddr2=$( echo ${ipaddr} )
        pattern=" |'"
        whois_org=$( whois ${name} | grep "Registrant Organization" | cut -d" " -f3- )
        if [[ $ipaddr2 =~ $pattern ]]; then
            ip1=$(echo ${ipaddr2} | cut -d" " -f1)
            whois_org1=$( whois ${ip1} | grep "Organization:" | cut -d" " -f4- )
            ip2=$(echo ${ipaddr2} | cut -d" " -f2)
            whois_org2=$( whois ${ip2} | grep "Organization:" | cut -d" " -f4- )
            basecidr1=$( whois ${ip1} |grep CIDR | cut -d" " -f12- )
            cidr1=$( echo $basecidr1 | sed 's/\,//g' | sort -u )
            prefix1=$( echo ${cidr1} | cut -d"/" -f2 )
            basecidr2=$( whois ${ip2} |grep CIDR | cut -d" " -f12- )
            cidr2=$( echo $basecidr2 | sed 's/\,//g' | sort -u )
            prefix2=$( echo ${cidr2} | cut -d"/" -f2 )
            echo "$ip1,$subname,$cidr1,\"$whois_org\",\"$whois_org2\"" >> ${dir}/${name}-DomainSubnets.csv
            echo "$ip2,$subname,$cidr2,\"$whois_org\",\"$whois_org2\"" >> ${dir}/${name}-DomainSubnets.csv
        else
            basecidr=$( whois $ipaddr |grep CIDR | cut -d" " -f12- )
            whois_org1=$( whois ${ipaddr} | grep "Organization:" | cut -d" " -f4- )
            cidr=$( echo $basecidr | sed 's/\,//g' | sort -u )
            prefix=$( echo $cidr | cut -d"/" -f2 )
            echo "$ipaddr,$subname,$cidr,\"$whois_org\",\"$whois_org1\"" >> ${dir}/${name}-DomainSubnets.csv
        fi
        echo "$count,$subname,$ipaddr2" >> ${dir}/${name}-DomainNames.csv
        
    done
    cd ~
    echo $'\n'
    echo "File stored in directory: ${dir} "
    echo $'\n'
    cd $dir
}

function verifyIPAddress() {
    apt-get install -qq -y jq
    echo ""
    path=$(pwd)
    read -p $'Enter the assessment number (e.g., 12345):  \n' -r parentname
    read -p $'Enter full path file location for IP file (e.g., /root/ips.txt):  \n' -r fileIP

    ## Search for old files and delete if same assessment number
    cmd0=$(test -f ./${parentname}_VerifyRanges.txt)
    cmd1=$(echo $?)
    if [ $cmd1 -eq 0 ]; then
        rm ${parentname}_Verify*
    fi
    rm raw0.txt raw1.txt 2> /dev/null

    ## nmap list scan using forced dns resolution
    ## curls the web address looking for existence of website
    ## hoping to observe either elements of the org or elements of another org
    ## trying to disprove ownership of entire range
    nmap -sL -R --dns-servers 1.1.1.1,8.8.8.8 -iL $fileIP >> raw0.txt
    echo "[ ] Searching for web content on hosts"
    for address in $(cat raw0.txt | cut -d" " -f5 | grep -E -iv "addresses|http"); do
        simpleSearch=$(curl --connect-timeout 5 -m 3 --no-keepalive --retry 0 -I -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.74 Safari/537.36 Edg/79.0.309.43" http://${address})
        if [[ "$simpleSearch" ]]; then
            echo "${address}" >> ${parentname}_VerifyReverseDNS.txt
            echo "${address}" >> raw1.txt
            echo " ${address} :: has content "
        else
            echo "${address}" >> ${parentname}_VerifyReverseDNS.txt
            echo -ne ".."
        fi
    done
    echo "[x] Search finished."

    ## similar to above, but looked at https-only. after testing this was not useful. Still here as a remnant in the event it can be used.
    # for address in $(cat raw0.txt | cut -d" " -f5 | grep -E -iv "addresses|http"); do
    #     simpleSearch=$(curl --connect-timeout 5 -m 3 --no-keepalive --retry 0 -I -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.74 Safari/537.36 Edg/79.0.309.43" https://${address})
    #     if [[ "$simpleSearch" ]]; then
    #         echo "https://${address}" >> raw1.txt
    #     else
    #         echo "NOTHING FOUND..."
    #     fi
    # done

    ## Similar approach, but nmap does not do dns resolution this time
    ## Quick searches for who owns the IP addresses
    cat raw1.txt | sort -u > ${parentname}_VerifyRanges.txt
    for ipAddr in $(nmap -sL -n -iL ${fileIP} | cut -d" " -f 5 | grep -E -v "addresses|http");do
        site=$(curl -s ipinfo.io/${ipAddr} | jq '.ip,.org,.hostname,.city,.region,.country')
        echo $site >> ${parentname}_VerifyLocation.txt
        echo $site
        z=$(( $RANDOM % 5 + 1 ))
        sleep $z    
    done

    ## checks for aquatone, and if not found, the script downloads it
    ## then runs aquatone
    location=$(which aquatone)
    if [[ "$location" ]]
        then
            echo ""
            echo "Aquatone already installed and linked!"
            echo ""
    else
        echo ""
        echo "Downloading Aquatone..."
        wget -O aquatone_linux_amd64_1.7.0.zip https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip 2> /dev/null
        unzip aquatone_linux_amd64_1.7.0.zip
        echo "Creating sym link to aquatone..."
        ln -s ${path}/aquatone /usr/sbin/aquatone
        echo "Aquatone is setup!"
        echo ""
    fi

    echo "[ ] Running aquatone on discovered web content"
    cat ${parentname}_VerifyRanges.txt | aquatone

    ## final cleanup
    rm raw0.txt raw1.txt
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
options=("Install Sublist3r" "Find Sub-Domains" "Verify IP Range" "Find WebApp Host")
select opt in "${options[@]}" "Quit"; do

    case "$REPLY" in
            
    #Prep
    1) install-Sublist3r;;

    2) gatherDomains;;

    3) verifyIPAddress;;
    
    4) webappHosting;;

    $(( ${#options[@]}+1 )) ) echo "Goodbye!"; break;;
    *) echo "Invalid option. Try another one.";continue;;

    esac
done
