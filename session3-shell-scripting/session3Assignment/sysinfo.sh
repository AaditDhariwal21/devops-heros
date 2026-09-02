#!/bin/bash

# system information script

current_date=$(date)
host=$(hostname)
user=$(whoami)

echo "Date: $current_date"
echo "Hostname: $host"
echo "Username: $user"

echo ""
echo "Disk usage:"
df -h

echo ""
echo "Running processes:"
ps

echo ""
read -p "Enter a folder name: " folder
read -p "Enter a file name: " filename

mkdir $folder
touch $folder/$filename

# save the processes into the file
ps > $folder/$filename

echo ""
echo "Processes saved in $folder/$filename"
cat $folder/$filename
