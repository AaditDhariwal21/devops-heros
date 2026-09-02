#!/bin/bash
# soft link vs hard link

mkdir -p ~/lab2 && cd ~/lab2 && rm -f file.txt hard.txt soft.txt

echo "hello world" > file.txt
ln file.txt hard.txt        # hard link
ln -s file.txt soft.txt     # soft link

echo "--- ls -li (first column is inode) ---"
ls -li

echo "--- now delete the original ---"
rm file.txt
ls -li

echo "--- hard link still works? ---"
cat hard.txt

echo "--- soft link still works? ---"
cat soft.txt

echo "--- deleting links ---"
rm soft.txt
rm hard.txt
ls
