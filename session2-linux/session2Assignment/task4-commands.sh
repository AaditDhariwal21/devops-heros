#!/bin/bash
# practising commands from the cheat sheet

mkdir -p ~/lab2/practice && cd ~/lab2/practice
printf 'apple\nbanana\napple\ncherry\n' > fruits.txt
printf 'INFO ok\nERROR failed\nINFO done\nERROR timeout\n' > app.log

echo "--- files and dirs ---"
pwd
ls -lh
wc -l fruits.txt

echo "--- grep ---"
grep ERROR app.log
grep -c ERROR app.log

echo "--- sort / uniq ---"
sort fruits.txt | uniq -c

echo "--- find ---"
find . -name "*.txt"

echo "--- permissions ---"
chmod 755 fruits.txt
ls -l fruits.txt

echo "--- disk and system ---"
df -h | head -3
free -h
uname -a

echo "--- processes ---"
ps aux | head -3

echo "--- tar ---"
tar -czf backup.tar.gz fruits.txt app.log
tar -tzf backup.tar.gz

echo "--- network ---"
ip -brief a
