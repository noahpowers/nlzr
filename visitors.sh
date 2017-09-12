#!/bin/bash

for z in $(cat /var/log/apache2/access.log | cut -d " " -f 1); do
    curl -s ipinfo.io/$z | grep -E "ip|org"
    echo -n $'\n'
done
