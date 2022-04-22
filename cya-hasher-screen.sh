#!/bin/bash

read -p "Full path to the share: " -r share_location
read -p "[ ] Assessment ID and Number:  " -r assessmentID

echo ""
echo "[+]  Discovering pentesting files through common formats"

asDate=$(date +"%Y%m%d")
curdir=$(pwd)
userdir=$( getent passwd "$USER" | cut -d: -f6 )

rm "${userdir}/fileresults.raw" &>/dev/null
rm "${userdir}/xa*" &>/dev/null
rm "${userdir}/*.raw" &>/dev/null

# Setting file types to search for.
cat <<-EOF > "${userdir}/searchfiletypes.txt"
bat
com
cpl
cs
dll
doc
docm
docx
dotm
exe
hta
htm
html
inf
iso
jar
key
lnk
msi
ppt
pptx
priv
ps
pub
scr
sfx
vb
vba
vbs
war
xls
xlsm
xlsx
xml
zip
EOF
cd "${userdir}" || exit
split -n l/6 "${userdir}/searchfiletypes.txt"

cd "${share_location}" || exit

#By multi-threading the search is saved 2x (220%) the time; 1min 10sec vs 2min 35sec
screen -S search-01 -d -m bash -c 'userdir=$( getent passwd "$USER" | cut -d: -f6 );for z in $(cat ${userdir}/xaa);do find . -type f -name "*.${z}" >> ${userdir}/1.raw;done;echo "1" >> ${userdir}/finished.raw'
screen -S search-02 -d -m bash -c 'userdir=$( getent passwd "$USER" | cut -d: -f6 );for z in $(cat ${userdir}/xab);do find . -type f -name "*.${z}" >> ${userdir}/2.raw;done;echo "2" >> ${userdir}/finished.raw'
screen -S search-03 -d -m bash -c 'userdir=$( getent passwd "$USER" | cut -d: -f6 );for z in $(cat ${userdir}/xac);do find . -type f -name "*.${z}" >> ${userdir}/3.raw;done;echo "3" >> ${userdir}/finished.raw'
screen -S search-04 -d -m bash -c 'userdir=$( getent passwd "$USER" | cut -d: -f6 );for z in $(cat ${userdir}/xad);do find . -type f -name "*.${z}" >> ${userdir}/4.raw;done;echo "4" >> ${userdir}/finished.raw'
screen -S search-05 -d -m bash -c 'userdir=$( getent passwd "$USER" | cut -d: -f6 );for z in $(cat ${userdir}/xae);do find . -type f -name "*.${z}" >> ${userdir}/5.raw;done;echo "5" >> ${userdir}/finished.raw'
screen -S search-06 -d -m bash -c 'userdir=$( getent passwd "$USER" | cut -d: -f6 );for z in $(cat ${userdir}/xaf);do find . -type f -name "*.${z}" >> ${userdir}/6.raw;done;echo "6" >> ${userdir}/finished.raw'

#Creating file so we don't get early errors that the file doesn't exist...
touch "${userdir}/finished.raw"

#Simple check to see when all screen sessions finish so we can move on
test=$( wc -w "${userdir}/finished.raw" | cut -d" " -f1 )
while [[ ${test} -lt 6 ]]
do 
	sleep 1
	#Would not advance to realize new input without reinitializing the input
	test=$(wc -w "${userdir}/finished.raw" | cut -d" " -f1)
done

echo "[+]  Obtaining hashes for discovered files"
echo ""

#Discovery Clean-Up
rm "${userdir}/xa*" &>/dev/null
rm "${userdir}/finished.raw" &>/dev/null

#Combining Results
for item in $(seq 1 6)
do
	cat "${userdir}/${item}.raw" >> "${userdir}/fileresults.raw"
done

echo "FILENAME,MD5,SHA1,SHA256"> "${userdir}/${assessmentID}-FileHashes-${asDate}.csv"

#Could get decent time savings by splitting the fileresults.raw file and multi-threading it like in discovery
#for x in $(cat "${userdir}/fileresults.raw")
cat "${userdir}/fileresults.raw" | while read -r line
do
    f=$(echo ${line} | sed 's|.*/||')          #filename without path
    m=$(md5sum "${line}"| cut -d' ' -f1)        #md5
    s1=$(sha1sum "${line}"| cut -d' ' -f1)      #sha1
    s256=$(sha256sum "${line}"| cut -d' ' -f1)  #sha256
    echo "${f},${m},${s1},${s256}" >> "${userdir}/${assessmentID}-FileHashes-${asDate}.csv"
done

echo "FINISHED!"
echo "Your CSV hash file is located here: ${userdir}/${assessmentID}-FileHashes-${asDate}.csv"

#Final Clean-Up
rm "${userdir}/searchfiletypes.txt" &>/dev/null
rm "${userdir}/*.raw" &>/dev/null
cd "${curdir}" || exit

echo ""
echo ""
