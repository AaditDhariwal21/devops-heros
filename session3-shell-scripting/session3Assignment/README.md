Session 3 - shell scripting

Script that prints date, hostname, username, disk usage and processes, uses variables
and read -p, then makes a folder + file and saves the process list into it with >.
Script is sysinfo.sh, full output in output.txt. Ran it as
printf 'myinfo\nprocess.log\n' | bash sysinfo.sh so the prompts don't show.

Output:

```
Date: Wed Sep  2 16:31:30 UTC 2026
Hostname: Legion
Username: root

Disk usage:
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdd       1007G  1.5G  955G   1% /
C:\             952G  790G  162G  83% /mnt/c

Running processes:
    PID TTY          TIME CMD
    336 pts/0    00:00:00 bash
    427 pts/0    00:00:00 ps

Processes saved in myinfo/process.log
    PID TTY          TIME CMD
    336 pts/0    00:00:00 bash
    430 pts/0    00:00:00 ps
```

What I learned:

$(command) is how you get a command's output into a variable - echo $hostname prints
nothing, it needs host=$(hostname). Got that wrong first.

> overwrites, >> appends. The PID in the file is different from the screen because ps
runs fresh each time.
