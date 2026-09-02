Session 2 - Linux homework

Four tasks: soft vs hard links, adduser vs useradd, journalctl, and practising the
basic commands from the cheat sheet. Ran it all in WSL Ubuntu because useradd and
journalctl don't exist on Windows. Scripts are task1-links.sh, task2-users.sh,
task3-journalctl.sh, task4-commands.sh. Full output is in output.txt.

Output (the interesting bits):

```
--- ls -li (first column is inode) ---
44974 -rw-r--r-- 2 root root 12 file.txt
44974 -rw-r--r-- 2 root root 12 hard.txt
44975 lrwxrwxrwx 1 root root  8 soft.txt -> file.txt

--- now delete the original ---
--- hard link still works? ---
hello world
--- soft link still works? ---
cat: soft.txt: No such file or directory
```

```
--- useradd (low level) ---
testuser1:x:1000:1000::/home/testuser1:/bin/sh
ls: cannot access '/home/testuser1': No such file or directory
--- adduser (recommended on ubuntu) ---
testuser2:x:1001:1001::/home/testuser2:/bin/bash
.bash_logout
.bashrc
.profile
```

```
--- logs for one service (cron) ---
Sep 02 16:19:05 Legion systemd[1]: Stopping cron.service...
Sep 02 16:19:05 Legion systemd[1]: Started cron.service - Regular background program processing daemon.
--- how much space logs use ---
Archived and active journals take up 128M in the file system.
```

What I learned:

The file name isn't the file. file.txt and hard.txt had the same inode (44974), so
they were one file with two names - deleting one didn't lose anything. The soft link
had its own inode and broke immediately since it only stores a path.

useradd didn't create a home directory at all and gave /bin/sh. adduser did the whole
setup (home dir, .bashrc, /bin/bash). So adduser for normal use on Ubuntu, useradd in
scripts because it's on every distro.

journalctl -u <service> is much easier than digging through /var/log files.
