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


## Parameters - RustConfiguration

current_user=$( /bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }' )
rustpw=$(openssl rand -base64 12)
rustkey="WSdBJzTi4s6Raini1kCeBbvxHGduv1oBbqzp30rinBU="
rustrelay="18.217.73.147"

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

