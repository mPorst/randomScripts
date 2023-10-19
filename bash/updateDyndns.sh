#!/bin/bash

# this bash script is an example for updating a dyndns ipv6 where your provider
# offers an update-ip that can be called via wget

urlString="FillThisFromYourDyndnsProvider"
# you can enforce a static /64 ipv6 suffix, but the PREFIX will still change
# here I grep for a fixed suffix to find the correct ip
# for making the suffix static your google buzzwords are:
# eui64 - tokenised ipv6 identifiers - ipv6-address-token - netplan (ubuntu)
ipString=$(ip addr | grep '::abcd:abcd' | cut -d ' ' -f6 | cut -d '/' -f1)

# last ip will be saved to a file so this script can run near constant
# without the fear of being persecuted for DOSing your dyndns provider
updateFile="lastUpdatedIp.txt"
if [ -f $updateFile ]; then
	# read last ip
        ipFromFile=$(head -n 1 $updateFile)
fi


if [ "$ipString" = "$ipFromFile" ]; then
        echo "IPs identical, no need to update"
else
        echo "new ip $ipString, updating..."
        updateUrl="${urlString}${ipString}"
        wget "${updateUrl}"
fi

# finally ALWAYS save the last ip
echo $ipString > $updateFile
