#!/bin/bash

# basic networking commands practice

echo "===== hostname -I ====="
hostname -I

echo "===== ip a ====="
ip -brief a

echo "===== ip r ====="
ip r

echo "===== ping ====="
ping -c 3 google.com

echo "===== netstat -tuln ====="
netstat -tuln | head -8

echo "===== ss -tuln ====="
ss -tuln | head -8

echo "===== nslookup ====="
nslookup google.com

echo "===== dig ====="
dig +short google.com

echo "===== traceroute ====="
traceroute -m 6 google.com

echo "===== curl ====="
curl -sI https://www.google.com | head -6

echo "===== arp ====="
arp -n

echo "===== whois ====="
whois google.com | head -12
