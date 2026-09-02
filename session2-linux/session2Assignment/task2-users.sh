#!/bin/bash
# adduser vs useradd

echo "--- what are they? ---"
file -b $(which useradd)
file -b $(which adduser)

echo "--- useradd (low level) ---"
useradd testuser1
grep testuser1 /etc/passwd
ls /home/testuser1

echo "--- adduser (recommended on ubuntu) ---"
adduser --disabled-password --gecos "" testuser2
grep testuser2 /etc/passwd
ls -a /home/testuser2

echo "--- cleanup ---"
userdel -r testuser1
deluser --remove-home testuser2
