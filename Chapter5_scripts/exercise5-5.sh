#!/bin/bash

# this is to connect to a remote server with Public/Priv keys

read -r -p "Comment to the Public key file: " COM
read -r -p "Enter key path (default is /home/.ssh/id_ed25519): " FN
read -r -p "Username of remote server: " UN
read -r -p "Host ip or Hostname: " HN

FN="${FN:-$HOME/.ssh/id_edd25519}"

mkdir -p "$(dirname "$FN")"
chmod 700 "$(dirname "$FN")"

#might  need to add error correcting here IF the file has already been created
if [[ -f "$FN" ]]; then
    echo "This already exists @ $FN - skipping command"
else
    ssh-keygen -t ed25519 -C "$COM" -N "" -f "$FN"
fi

ssh-copy-id -i "${FN}.pub" "${UN}"@"${HN}"

echo "Testing login to $HN..."
ssh "${UN}@${HN}"
exit 0