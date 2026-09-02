Session 4 - networking commands

Task 1 was to practise the basic networking commands, task 2 was to put them in a .md
file with the output and a short explanation of each. That file is
networking-commands.md. netcommands.sh runs them all, raw output is in output.txt.
Had to apt install net-tools dnsutils traceroute whois first since only ip, ping, ss
and curl were already there.

Commands covered: hostname, ip a, ip r, ping, netstat, ss, nslookup, dig, traceroute,
curl, arp, whois.

What I learned:

ip a and ip r are the new versions of ifconfig and route, and ss replaces netstat.
The old ones still work but aren't installed by default anymore.

traceroute was the most interesting one - you can actually see the packet go from my
gateway to my ISP and out. The * * * hops are just routers not replying.

Also DNS is a separate step from connecting - nslookup turns the name into an IP
first, then ping/curl uses that IP.
