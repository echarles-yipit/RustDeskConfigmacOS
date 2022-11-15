#!/bin/bash

#########################################
##
## Use Jamf to deploy RustDesk configuration
## Jamf parameters defined below
## $4 - set server URL in parameter 4, add 8443 into variable in policy payload if self-hosted
## $5 - set encoded username:password in parameter 5
## $6 - set EA ID in parameter 6
## $7 - set RustDesk public key for your server in parameter 7
## $8 - set RestDeskURL in parameter 8
##
#########################################

## Parameters - Jamf API

jamfserver="$4"
APIauth=$(openssl enc -base64 -d <<< "$5")
V_SerialNumber=$(system_profiler SPHardwareDataType | grep "Serial Number (system)" | awk '{print $4}')
eaID="$6"

## Parameters - RustConfiguration

current_user=$( /bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }' )
rustpw=$(openssl rand -base64 12)
rustkey="$7"
rustrelay="$8"

#########################################

mkdir -p /Users/$current_user/Library/Preferences/com.carriez.RustDesk

echo "rendezvous_server = '$rustrelay'
nat_type = 1
serial = 3

[options]
custom-rendezvous-server = '$rustrelay'
rendezvous-servers = 'rs-ny.rustdesk.com,rs-sg.rustdesk.com,rs-cn.rustdesk.com'
key = '$rustkey'
relay-server = '$rustrelay'" > /Users/$current_user/Library/Preferences/com.carriez.RustDesk/RustDesk2.toml

echo "password = '$rustpw'" > /Users/$current_user/Library/Preferences/com.carriez.RustDesk/RustDesk.toml

# Submit unmanage payload to the Jamf Pro Server

curl -sku "$APIauth" -H "Content-type: application/xml" "https://$jamfserver/JSSResource/computers/serialnumber/$V_SerialNumber" -X PUT -d "<computer><extension_attributes><extension_attribute><id>$eaID</id><value>$rustpw</value></extension_attribute></extension_attributes></computer>"
