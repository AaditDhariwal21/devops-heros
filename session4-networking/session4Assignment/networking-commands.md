# Networking commands practice

Ran these in WSL Ubuntu. Full raw output is in output.txt.

## hostname -I

```
172.17.255.201
```

Shows my machine's IP address. -I gives just the IP instead of the machine name.

## ip a

```
lo               UNKNOWN        127.0.0.1/8 10.255.255.254/32 ::1/128
eth0             UP             172.17.255.201/20 fe80::215:5dff:fe56:f637/64
```

Lists the network interfaces. lo is loopback (127.0.0.1, the machine talking to
itself) and eth0 is the real one. /20 is the subnet mask. Used -brief to keep it short.

## ip r

```
default via 172.17.240.1 dev eth0 proto kernel
172.17.240.0/20 dev eth0 proto kernel scope link src 172.17.255.201
```

The routing table. "default via" is the gateway - anything not on my own network gets
sent to 172.17.240.1 first.

## ping

```
PING google.com (142.250.207.174) 56(84) bytes of data.
64 bytes from pnbomb-bl-in-f14.1e100.net (142.250.207.174): icmp_seq=1 ttl=116 time=26.7 ms
64 bytes from pnbomb-bl-in-f14.1e100.net (142.250.207.174): icmp_seq=2 ttl=116 time=28.0 ms

--- google.com ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 26.536/27.087/28.016/0.660 ms
```

Checks if a host is reachable and how long it takes. 0% packet loss = connection is
fine. time= is the round trip in ms. -c 3 stops it after 3 packets.

## netstat -tuln

```
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN
udp        0      0 127.0.0.54:53           0.0.0.0:*
```

Shows which ports are open and listening. t=tcp, u=udp, l=listening, n=show numbers
instead of names. Port 53 here is DNS.

## ss -tuln

```
Netid State  Recv-Q Send-Q  Local Address:Port Peer Address:Port
udp   UNCONN 0      0          127.0.0.54:53        0.0.0.0:*
udp   UNCONN 0      0           127.0.0.1:323       0.0.0.0:*
```

Same job as netstat but newer and faster. netstat is the old one, ss is what you're
supposed to use now. Same flags.

## nslookup

```
Server:		10.255.255.254
Address:	10.255.255.254#53

Non-authoritative answer:
Name:	google.com
Address: 142.250.207.174
Address: 2404:6800:4009:807::200e
```

Looks up the IP for a domain name (DNS). "Server" at the top is which DNS server
answered. Gave both an IPv4 and an IPv6 address.

## dig

```
142.250.207.174
```

Also does DNS lookups but gives way more detail than nslookup normally. +short cuts
it down to just the IP.

## traceroute

```
traceroute to google.com (142.250.207.174), 6 hops max, 60 byte packets
 1  Legion.mshome.net (172.17.240.1)  0.267 ms
 2  * wifi.height8tech.com (10.114.0.1)  10.687 ms
 3  * * *
 6  * 115.112.15.114.static-chennai.vsnl.net.in (115.112.15.114)  15.090 ms
```

Shows every router the packet goes through to reach the destination. Hop 1 is my own
gateway, then my ISP. The * * * lines are routers that don't reply to the probe.
Useful for finding where a connection is breaking.

## curl -I

```
HTTP/2 200
content-type: text/html; charset=ISO-8859-1
date: Wed, 02 Sep 2026 16:33:17 GMT
```

Makes an HTTP request. -I only fetches the headers, not the page. 200 means it worked.

## arp -n

```
Address                  HWtype  HWaddress           Flags Mask            Iface
172.17.240.1             ether   00:15:5d:6b:56:b4   C                     eth0
```

Maps IP addresses to MAC addresses on the local network. IP is used for routing across
networks, MAC is the actual hardware address used on the local one.

## whois

```
   Domain Name: GOOGLE.COM
   Registrar WHOIS Server: whois.markmonitor.com
   Creation Date: 1997-09-15T04:00:00Z
   Registry Expiry Date: 2028-09-14T04:00:00Z
   Registrar: MarkMonitor Inc.
```

Shows who registered a domain and when. google.com was registered in 1997.
