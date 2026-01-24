#!/bin/bash
### creating user accounts

read -r -p "How many days do you want passwords to last? (default is 99999): " DYS
read -r -p "What editor do you want vim or nano: " ENV
read -r -p "What is the name of the user that you want to add?: " USR1
read -r -p "How long before you can change the password again?: " CNG
read -r -p "How long do you want the password to last for?: " LEN
read -r -p "How long before expire do you want a reminder?: " EXP
read -r -p "User 2: " USR2
read -r -p "User 3: " USR3


if [[ -z "$DYS" ]]; then
    exit 0
elif [[ ! "$DYS" =~ ^[0-9]+$ ]];then
    echo "ERROR: '$DYS' is not a valid number (contains non-digits)." >&2
    exit 1
elif [[ "$DYS" -gt 99999 ]]; then
    echo "Must be in range" >&2
    exit 1
else
    sudo cp /etc/login.defs /etc/login.defs.bak
    sudo sed -i "s/^PASS_MAX_DAYS.*/PASS_MAX_DAYS $DYS/" /etc/login.defs
fi

sudo mkdir -p /etc/skel/fotos && sudo mkdir -p /etc/skel/files

if [[ "$ENV" == vim ]]; then
    sudo sed -i '$a export EDITOR=/usr/bin/vim' /etc/skel/.bashrc
elif [[ "$ENV" == nano ]]; then
    sudo sed -i '$a export EDITOR=/usr/bin/nano' /etc/skel/.bashrc
else
    echo "Not one of the 2 options" >&2
    exit 1
fi

#adding user
sudo useradd "$USR1" && sudo id "$USR1"

#adding password
echo "$USR1:password" | sudo chpasswd
sudo passwd -n "$CNG" -w "$EXP" -x "$LEN" "$USR1"

for i in "$USR2" "$USR3"; do
    sudo useradd "$i";
done

sudo grep "$USR2" /etc/passwd /etc/shadow /etc/group

exit 0