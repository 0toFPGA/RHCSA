#!/bin/bash
set -euo pipefail

### run with the following ###
# scp exercise6-2.sh <user>@<ip/hostname>:/tmp/
# ssh -tt <student>@<ip/hostname> 'sudo bash /tmp/exercise6-2.sh'


# Switching User Accounts this seems hard lol
echo "We need to add 2 Users pick 2 names"
read -r -p "Name 1(full sudo user): " N1
read -r -p "Name 2(restricted sudo user): " N2

useradd "$N1"; useradd "$N2"

echo "$N1:password" | chpasswd
echo "$N2:password" | chpasswd

# I have to open a su - $N2 and I am not sure how to do it
if sudo -u "$N1" sudo ls /root 2>/dev/null; then
    echo "Not expected: $N1 has sudo" || true
else
    echo "That is expected"
fi

whoami
echo "$N1 ALL=(ALL) ALL" | sudo tee "/etc/sudoers.d/$N1" >/dev/null
chmod 440 "/etc/sudoers.d/$N1"
visudo -cf "/etc/sudoers.d/$N1"

if sudo -u "$N1" sudo ls /root 2>/dev/null; then
    echo "That is expected"
else
    echo "Not expected: $N1 has root?"
fi

sudo ls -l /root
echo "$N2 ALL=/usr/sbin/useradd,/usr/bin/passwd,!/usr/bin/passwd root" | sudo tee "/etc/sudoers.d/$N2"
chmod 440 "/etc/sudoers.d/$N2"
visudo -cf "/etc/sudoers.d/$N2"

if sudo -u "$N2" sudo passwd "$N1" 2>/dev/null; then
    echo "That is expected"
else
    echo "Check your sudoers file? it failed but silently"
fi

if sudo -u "$N2" sudo passwd root 2>/dev/null; then
    echo "NOT expected"
else
    echo "Expected"
fi
exit