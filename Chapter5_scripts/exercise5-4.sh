#!/bin/bash

#This is a script that opens a sftp connection to a remote server and copies a
#file from the local machine to the remote server.

#open sftp connection and copy file
read -p "Enter remote username: " RU
read -p "Enter remote host: (IP or hostname)" RH
read -p "Enter local file path to copy: " LF
read -p "Enter remote dir to copy file to: " RD

sftp ${RU}@${RH} <<EOF
put ${LF} ${RD}
bye
EOF
echo "File ${LF} has been copied to ${RU}@${RH}:${RD}"
exit 0