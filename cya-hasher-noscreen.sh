#!/bin/bash

read -p "Full path to the share: " -r share_location
read -p "[ ] Assessment ID and Number:  " -r assessmentID

echo ""
echo "[+]  Gathering pentesting files and hashing discovered files"
echo ""

asDate=$(date +"%Y%m%d")
curdir=$(pwd)
userdir=$( getent passwd "$USER" | cut -d: -f6 )

rm ${userdir}/fileresults.raw &>/dev/null

# Setting file types to search for; XLSX and DOCX are for macros.
cat <<-EOF > ${userdir}/searchfiletypes.txt
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
zip
EOF

cd $share_location
for z in $(cat ${userdir}/searchfiletypes.txt);
do
    find . -type f -name "*.${z}" >> ${userdir}/fileresults.raw
done

echo "FILENAME,MD5,SHA1,SHA256"> ${userdir}/${assessmentID}-FileHashes-${asDate}.csv
for x in $(cat ${userdir}/fileresults.raw)
do 
    f=$(echo ${x} | sed 's|.*/||')          #filename without path
    m=$(md5sum ${x} | cut -d' ' -f1)        #md5
    s1=$(sha1sum ${x} | cut -d' ' -f1)      #sha1
    s256=$(sha256sum ${x} | cut -d' ' -f1)  #sha256
    echo "${f},${m},${s1},${s256}" >> ${userdir}/${assessmentID}-FileHashes-${asDate}.csv
done
rm ${userdir}/searchfiletypes.txt &>/dev/null
rm ${userdir}/fileresults.raw &>/dev/null
cd $curdir

echo "FINISHED!"
echo "Your CSV hash file is located here: ${userdir}/${assessmentID}-FileHashes-${asDate}.csv"

echo ""
echo ""