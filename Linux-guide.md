# Linux Administration Guide

A practical, example-driven reference for core Linux system administration: users, files, permissions, security, networking, disks, processes, and monitoring.

> Tested on Debian/Ubuntu and RHEL/CentOS/Fedora family distros. Where commands differ, both are noted.

---

## Table of Contents

1. [User & Group Management](#1-user--group-management)
2. [File Management](#2-file-management)
3. [File Permissions & Ownership](#3-file-permissions--ownership)
4. [Process Management](#4-process-management)
5. [Disk & Storage Management](#5-disk--storage-management)
6. [Networking](#6-networking)
7. [Security](#7-security)
8. [Monitoring & Logging](#8-monitoring--logging)
9. [Package Management](#9-package-management)
10. [systemd & Services](#10-systemd--services)
11. [Scheduling: cron & at](#11-scheduling-cron--at)
12. [Text Processing (grep, sed, awk)](#12-text-processing-grep-sed-awk)
13. [Shell Scripting Basics](#13-shell-scripting-basics)
14. [Environment Variables & Shell Config](#14-environment-variables--shell-config)
15. [Archiving & Compression](#15-archiving--compression)
16. [Quick Reference Cheat Sheet](#16-quick-reference-cheat-sheet)

---

## 1. User & Group Management

Linux is multi-user by design. User info lives in `/etc/passwd` (accounts), `/etc/shadow` (hashed passwords), and `/etc/group` (groups).

### Key files
| File | Purpose |
|---|---|
| `/etc/passwd` | Username, UID, GID, home dir, shell |
| `/etc/shadow` | Encrypted passwords, expiry policy |
| `/etc/group` | Group definitions and members |
| `/etc/sudoers` | Who can run commands as root (edit with `visudo`) |

### Creating & managing users

```bash
# Create a new user with a home directory
sudo useradd -m -s /bin/bash manasseh

# Create a user and immediately set a password
sudo useradd -m manasseh && sudo passwd manasseh

# Modify an existing user (e.g., change shell)
sudo usermod -s /bin/zsh manasseh

# Add a user to a supplementary group (e.g., docker or sudo)
sudo usermod -aG sudo manasseh      # Debian/Ubuntu
sudo usermod -aG wheel manasseh     # RHEL/Fedora

# Lock / unlock an account
sudo passwd -l manasseh
sudo passwd -u manasseh

# Delete a user (and their home directory)
sudo userdel -r manasseh
```

> **Note:** `-aG` (append + groups) is important — using `-G` alone *overwrites* all existing supplementary groups.

### Group management

```bash
sudo groupadd developers
sudo groupmod -n devs developers        # rename a group
sudo gpasswd -a manasseh developers     # add user to group
sudo gpasswd -d manasseh developers     # remove user from group
sudo groupdel devs
```

### Checking identity & membership

```bash
whoami              # current user
id manasseh         # UID, GID, and all groups for a user
groups manasseh      # groups a user belongs to
last                # login history
who                 # who is currently logged in
w                   # who is logged in + what they're doing
```

### Switching users & privilege escalation

```bash
su - manasseh        # switch to user manasseh (full login shell)
sudo <command>       # run a single command as root
sudo -i              # start a root login shell
sudo -u appuser <cmd> # run command as a specific non-root user
```

### Password policy

```bash
sudo chage -l manasseh          # view password expiry info
sudo chage -M 90 manasseh       # force password change every 90 days
```

---

## 2. File Management

### Navigation & inspection

```bash
pwd                     # print working directory
ls -lah                 # long listing, human-readable sizes, hidden files
cd /var/log             # change directory
tree -L 2               # show directory structure 2 levels deep
find /etc -name "*.conf"        # find files by name
find . -type f -mtime -7         # files modified in the last 7 days
find . -size +100M               # files larger than 100MB
locate nginx.conf                # fast search using a prebuilt index (updatedb)
```

### Creating, copying, moving, deleting

```bash
mkdir -p project/src/utils     # -p creates parent dirs as needed
touch notes.txt                # create empty file / update timestamp
cp file.txt backup.txt         # copy a file
cp -r src/ dest/                # copy a directory recursively
mv old_name.txt new_name.txt    # rename or move
rm file.txt                     # delete a file
rm -rf temp_dir/                 # force-delete a directory recursively (use carefully!)
```

> **Warning:** `rm -rf` has no undo. Double-check the path (especially with variables in scripts) before running it.

### Viewing file contents

```bash
cat file.txt             # print entire file
less file.txt             # paginated view (q to quit, / to search)
head -n 20 file.txt        # first 20 lines
tail -n 20 file.txt        # last 20 lines
tail -f /var/log/syslog     # follow a file live (great for logs)
wc -l file.txt             # count lines
diff file1.txt file2.txt    # compare two files
```

### Links

```bash
ln -s /path/to/original /path/to/symlink   # symbolic (soft) link
ln /path/to/original /path/to/hardlink     # hard link
```

- **Symbolic link:** a pointer/shortcut; breaks if the original is deleted.
- **Hard link:** another name for the same inode/data; survives deletion of the original name.

### Searching inside files

```bash
grep -r "TODO" ./src              # recursive search for a string
grep -i "error" app.log            # case-insensitive search
```

---

## 3. File Permissions & Ownership

Every file/directory has an **owner**, a **group**, and permissions for **owner / group / others**.

```bash
ls -l file.txt
# -rw-r--r-- 1 manasseh developers 1024 Jul 13 10:00 file.txt
```

Breaking down `-rw-r--r--`:

| Segment | Meaning |
|---|---|
| `-` | File type (`-` file, `d` directory, `l` symlink) |
| `rw-` | Owner: read, write, no execute |
| `r--` | Group: read only |
| `r--` | Others: read only |

### Permission values

| Symbol | Binary | Value |
|---|---|---|
| `r` (read) | 100 | 4 |
| `w` (write) | 010 | 2 |
| `x` (execute) | 001 | 1 |

Add them up per group: `rwx` = 7, `rw-` = 6, `r-x` = 5, `r--` = 4.

### Changing permissions with chmod

```bash
chmod 755 script.sh        # rwxr-xr-x — owner full, others read+execute
chmod 644 file.txt         # rw-r--r-- — standard file default
chmod u+x script.sh        # add execute for owner only
chmod go-w file.txt        # remove write for group and others
chmod -R 755 project/      # apply recursively to a directory
```

### Changing ownership with chown / chgrp

```bash
sudo chown manasseh file.txt              # change owner
sudo chown manasseh:developers file.txt   # change owner AND group
sudo chown -R manasseh:developers project/  # recursive
sudo chgrp developers file.txt             # change group only
```

### Special permissions

```bash
chmod u+s /usr/bin/some_binary   # SUID — runs with owner's privileges
chmod g+s shared_dir/            # SGID — new files inherit dir's group
chmod +t /tmp                    # Sticky bit — only owner can delete their own files
```

- **SUID (4000):** executable runs as the file owner (e.g., `passwd` runs as root even when a regular user launches it).
- **SGID (2000):** files created in the directory inherit the directory's group — useful for shared team folders.
- **Sticky bit (1000):** in a shared/world-writable directory (like `/tmp`), users can only delete their own files.

### Access Control Lists (ACLs) — finer-grained than owner/group/other

```bash
getfacl file.txt                       # view ACLs
setfacl -m u:otheruser:rw file.txt      # give a specific user rw access
setfacl -m g:interns:r file.txt         # give a specific group read access
setfacl -x u:otheruser file.txt         # remove that entry
```

### Default umask

`umask` controls the default permissions new files/directories get.

```bash
umask            # view current mask (e.g., 0022)
umask 0027        # set a stricter default (owner full, group read, others none)
```

A umask of `022` means new files default to `644` and new directories to `755` (subtracted from `666`/`777`).

---

## 4. Process Management

### Viewing processes

```bash
ps aux                     # snapshot of all running processes
ps aux | grep nginx         # find a specific process
top                         # live, interactive process viewer
htop                        # nicer live viewer (may need: sudo apt install htop)
pstree                      # process tree showing parent/child relationships
```

### Foreground, background, and jobs

```bash
long_task.sh &         # run in background
jobs                    # list background jobs in current shell
fg %1                   # bring job 1 to foreground
bg %1                   # resume job 1 in background
Ctrl+Z                  # suspend the current foreground process
```

### Killing processes

```bash
kill 1234              # send SIGTERM (graceful stop) to PID 1234
kill -9 1234            # send SIGKILL (force kill, no cleanup)
killall firefox         # kill all processes matching a name
pkill -f "node server"  # kill by matching command line pattern
```

| Signal | Number | Meaning |
|---|---|---|
| SIGHUP | 1 | Reload/hangup |
| SIGINT | 2 | Interrupt (Ctrl+C) |
| SIGTERM | 15 | Graceful terminate (default) |
| SIGKILL | 9 | Force kill, cannot be caught/ignored |

### Priority (nice values)

Lower nice value = higher priority. Range: **-20 (highest)** to **19 (lowest)**.

```bash
nice -n 10 ./build.sh          # start a process with lower priority
renice -n 5 -p 1234             # change priority of a running process
```

### Persisting processes after logout

```bash
nohup ./long_task.sh &          # ignore SIGHUP, keeps running after logout
disown -h %1                    # detach a job from the shell
screen -S mysession              # start a detachable terminal session
tmux new -s mysession            # modern alternative to screen
```

---

## 5. Disk & Storage Management

### Viewing disk usage

```bash
df -h                    # disk space per mounted filesystem, human-readable
du -sh /var/log           # total size of a directory
du -h --max-depth=1 /home  # size of each subdirectory, one level deep
lsblk                     # list block devices (disks & partitions) as a tree
blkid                     # show UUIDs and filesystem types
```

### Partitioning

```bash
sudo fdisk -l              # list partitions on all disks
sudo fdisk /dev/sdb          # interactive partition editor (classic MBR/GPT-aware)
sudo parted /dev/sdb print   # view partition table with parted
```

### Filesystems

```bash
sudo mkfs.ext4 /dev/sdb1     # format a partition as ext4
sudo mkfs.xfs /dev/sdb1      # format as XFS
```

### Mounting

```bash
sudo mount /dev/sdb1 /mnt/data       # mount a partition
sudo umount /mnt/data                # unmount
mount | column -t                    # list currently mounted filesystems, readable
```

Persistent mounts go in `/etc/fstab`:
```
UUID=xxxx-xxxx  /mnt/data   ext4   defaults   0   2
```

### Swap

```bash
sudo fallocate -l 2G /swapfile     # create a 2GB file
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile               # enable it
swapon --show                       # verify
free -h                             # view RAM + swap usage
```

### LVM (Logical Volume Manager) — for flexible resizing

```bash
sudo pvcreate /dev/sdb1              # mark a partition as a physical volume
sudo vgcreate vg_data /dev/sdb1       # create a volume group
sudo lvcreate -L 20G -n lv_app vg_data  # create a logical volume
sudo lvextend -L +10G /dev/vg_data/lv_app   # grow it later
sudo resize2fs /dev/vg_data/lv_app          # resize the filesystem to match
```

### Checking disk health & I/O

```bash
sudo smartctl -a /dev/sda    # SMART health info (needs smartmontools)
iostat -x 1                  # I/O stats, refreshed every second (needs sysstat)
```

---

## 6. Networking

### Interfaces & IP addresses

```bash
ip a                     # show all interfaces and IPs (modern)
ip addr show eth0          # show one interface
ifconfig                  # legacy equivalent (may need net-tools)
ip link set eth0 up        # bring an interface up
```

### Connectivity & routing

```bash
ping -c 4 google.com          # send 4 ICMP pings
traceroute google.com          # show the route packets take
ip route                       # view routing table
sudo ip route add default via 192.168.1.1   # set default gateway
```

### DNS

```bash
cat /etc/resolv.conf       # current DNS servers
nslookup google.com          # query DNS
dig google.com                # more detailed DNS query
dig +short google.com          # just the answer
```

### Ports & connections

```bash
ss -tulnp                 # modern: listening TCP/UDP ports + owning process
netstat -tulnp             # legacy equivalent
sudo lsof -i :8080          # what process is using port 8080
```

### Transferring & testing

```bash
curl -I https://example.com        # fetch just the HTTP headers
curl -o file.zip https://example.com/file.zip   # download a file
wget https://example.com/file.zip                # alternative downloader
scp file.txt user@remote:/home/user/              # secure copy over SSH
rsync -avz src/ user@remote:/dest/                 # efficient sync (only changed data)
```

### SSH

```bash
ssh user@192.168.1.10                 # connect to a remote host
ssh -p 2222 user@192.168.1.10          # connect on a non-default port
ssh-keygen -t ed25519 -C "you@email"    # generate a keypair
ssh-copy-id user@192.168.1.10           # install your public key on a remote host
```

### Firewall basics

```bash
# UFW (Ubuntu's friendlier firewall wrapper)
sudo ufw status
sudo ufw allow 22/tcp
sudo ufw allow OpenSSH
sudo ufw enable

# firewalld (RHEL/Fedora)
sudo firewall-cmd --list-all
sudo firewall-cmd --add-port=8080/tcp --permanent
sudo firewall-cmd --reload
```

---

## 7. Security

### Keeping the system patched

```bash
sudo apt update && sudo apt upgrade -y     # Debian/Ubuntu
sudo dnf upgrade --refresh                 # Fedora/RHEL
```

### SSH hardening (`/etc/ssh/sshd_config`)

```
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
Port 2222
AllowUsers manasseh
```
Then reload: `sudo systemctl restart sshd`

Disabling password auth (key-only login) and root login are two of the highest-value SSH hardening steps.

### Fail2ban — auto-block brute-force attempts

```bash
sudo apt install fail2ban
sudo systemctl enable --now fail2ban
sudo fail2ban-client status sshd     # see currently banned IPs
```

### Mandatory access control

```bash
# SELinux (RHEL/Fedora)
getenforce                  # check current mode
sudo setenforce 1            # set to Enforcing

# AppArmor (Ubuntu/Debian)
sudo aa-status               # view loaded profiles
```

### Auditing & integrity

```bash
sudo apt install lynis && sudo lynis audit system   # security audit tool
sudo apt install rkhunter && sudo rkhunter --check    # rootkit scanner
sha256sum file.iso                                    # verify file integrity/checksum
```

### Sudo access control

Edit safely with `visudo` (validates syntax before saving):
```bash
sudo visudo
```
```
manasseh ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx
```
This grants passwordless sudo for one specific command only — much safer than blanket `NOPASSWD: ALL`.

### File integrity monitoring

```bash
sudo apt install aide
sudo aideinit                 # build a baseline database
sudo aide --check              # compare current state vs baseline
```

---

## 8. Monitoring & Logging

### Live resource usage

```bash
top                    # CPU, memory, process snapshot (live)
htop                   # friendlier version of top
vmstat 1                # memory, swap, CPU stats every 1s
free -h                 # memory and swap summary
uptime                  # load averages + how long the system's been up
```

### Disk & network monitoring

```bash
iostat -x 1             # disk I/O stats (sysstat package)
iftop                   # live bandwidth usage per connection
nload                   # simple live bandwidth graph
```

### Logs

```bash
journalctl                       # view systemd logs
journalctl -u nginx.service        # logs for a specific service
journalctl -f                     # follow logs live
journalctl --since "1 hour ago"     # filter by time
tail -f /var/log/syslog             # classic log-tailing (Debian/Ubuntu)
tail -f /var/log/messages           # equivalent on RHEL-based systems
dmesg | tail                        # recent kernel messages (boot/hardware)
```

### System info snapshot

```bash
uname -a           # kernel and system info
hostnamectl         # hostname, OS, kernel details
lscpu               # CPU architecture details
lsusb / lspci        # connected USB/PCI devices
```

---

## 9. Package Management

```bash
# Debian/Ubuntu (APT)
sudo apt update                   # refresh package index
sudo apt install nginx             # install a package
sudo apt remove nginx               # remove but keep config
sudo apt purge nginx                 # remove including config
sudo apt list --installed             # list installed packages

# RHEL/Fedora/CentOS (DNF/YUM)
sudo dnf install nginx
sudo dnf remove nginx
sudo dnf list installed

# Arch (Pacman)
sudo pacman -S nginx
sudo pacman -R nginx

# Universal: Snap / Flatpak
sudo snap install code --classic
flatpak install flathub org.gimp.GIMP
```

---

## 10. systemd & Services

```bash
sudo systemctl status nginx      # check service status
sudo systemctl start nginx        # start now
sudo systemctl stop nginx          # stop now
sudo systemctl restart nginx        # restart
sudo systemctl enable nginx          # start automatically on boot
sudo systemctl disable nginx          # don't start on boot
systemctl list-units --type=service    # list all services
```

### Minimal custom service (`/etc/systemd/system/myapp.service`)

```ini
[Unit]
Description=My Node App
After=network.target

[Service]
ExecStart=/usr/bin/node /opt/myapp/server.js
Restart=always
User=appuser
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload      # re-read unit files after changes
sudo systemctl enable --now myapp   # enable + start in one command
```

---

## 11. Scheduling: cron & at

### Cron (recurring jobs)

```bash
crontab -e            # edit current user's cron jobs
crontab -l             # list current user's cron jobs
sudo crontab -e -u www-data   # edit another user's crontab
```

Cron syntax: `minute hour day-of-month month day-of-week command`

```
# Run a backup script every day at 2:30 AM
30 2 * * * /home/manasseh/scripts/backup.sh

# Run every 15 minutes
*/15 * * * * /home/manasseh/scripts/healthcheck.sh

# Run every Monday at 9am
0 9 * * 1 /home/manasseh/scripts/weekly_report.sh
```

### at (one-time future jobs)

```bash
echo "./cleanup.sh" | at 23:00      # run once at 11 PM tonight
atq                                   # list pending at jobs
atrm 3                                # remove job number 3
```

---

## 12. Text Processing (grep, sed, awk)

### grep — search

```bash
grep "error" app.log                  # basic search
grep -i "error" app.log                # case-insensitive
grep -r "TODO" ./src                    # recursive
grep -v "debug" app.log                  # invert match (lines NOT containing "debug")
grep -c "error" app.log                   # count matches
grep -E "error|warning" app.log            # extended regex, multiple patterns
```

### sed — stream editor (find & replace)

```bash
sed 's/foo/bar/' file.txt              # replace first match per line (prints, doesn't modify file)
sed 's/foo/bar/g' file.txt              # replace ALL matches per line
sed -i 's/foo/bar/g' file.txt            # edit the file in place
sed -n '5,10p' file.txt                   # print only lines 5–10
```

### awk — column/field processing

```bash
awk '{print $1}' file.txt                  # print the first column
awk -F',' '{print $2}' data.csv              # use comma as the field separator
awk '{sum += $3} END {print sum}' file.txt    # sum values in column 3
ps aux | awk '{print $2, $11}'                 # print PID and command from ps output
```

---

## 13. Shell Scripting Basics

```bash
#!/bin/bash
# A simple example script

NAME="World"
echo "Hello, $NAME!"

# Conditionals
if [ -f "/etc/hosts" ]; then
  echo "hosts file exists"
else
  echo "not found"
fi

# Loops
for i in 1 2 3; do
  echo "Number: $i"
done

# Reading arguments
echo "Script name: $0"
echo "First argument: $1"
echo "All arguments: $@"

# Functions
greet() {
  echo "Hi, $1"
}
greet "Manasseh"

# Exit codes
if ! ping -c 1 google.com &> /dev/null; then
  echo "No internet"
  exit 1
fi
```

```bash
chmod +x script.sh    # make it executable
./script.sh            # run it
```

---

## 14. Environment Variables & Shell Config

```bash
echo $HOME              # print a variable
export MY_VAR="value"    # set for current shell + child processes
env                       # list all environment variables
printenv PATH              # print one specific variable
unset MY_VAR                # remove a variable
```

Persistent config files (loaded in this general order):
| File | Scope |
|---|---|
| `/etc/environment` | System-wide, all users |
| `/etc/profile` | System-wide, login shells |
| `~/.bash_profile` / `~/.profile` | Per-user, login shells |
| `~/.bashrc` | Per-user, interactive non-login shells |

```bash
# Add a directory to PATH permanently (add this line to ~/.bashrc)
export PATH="$HOME/bin:$PATH"
source ~/.bashrc     # reload without restarting the shell
```

---

## 15. Archiving & Compression

```bash
tar -cvf archive.tar folder/          # create an archive (no compression)
tar -xvf archive.tar                    # extract
tar -czvf archive.tar.gz folder/         # create with gzip compression
tar -xzvf archive.tar.gz                  # extract a .tar.gz
tar -tzvf archive.tar.gz                   # list contents without extracting

zip -r archive.zip folder/                 # create a zip
unzip archive.zip                            # extract a zip

gzip file.txt          # compress a single file -> file.txt.gz
gunzip file.txt.gz      # decompress it back
```

---

## 16. Quick Reference Cheat Sheet

| Task | Command |
|---|---|
| Add a user | `sudo useradd -m -s /bin/bash <user>` |
| Add user to group | `sudo usermod -aG <group> <user>` |
| Change permissions | `chmod 755 <file>` |
| Change owner | `sudo chown user:group <file>` |
| List processes | `ps aux` / `top` / `htop` |
| Kill a process | `kill -9 <pid>` |
| Disk usage | `df -h` / `du -sh <dir>` |
| Mount a drive | `sudo mount /dev/sdX /mnt/point` |
| Show IP/interfaces | `ip a` |
| Check open ports | `ss -tulnp` |
| Firewall allow port | `sudo ufw allow <port>/tcp` |
| Service control | `sudo systemctl start/stop/restart <svc>` |
| View logs | `journalctl -u <service> -f` |
| Install package | `sudo apt install <pkg>` / `sudo dnf install <pkg>` |
| Schedule a job | `crontab -e` |
| Search text | `grep -r "pattern" .` |
| Compress folder | `tar -czvf out.tar.gz folder/` |

---

## Suggested Learning Path

1. Get comfortable with navigation, permissions, and `sudo` first — everything else builds on this.
2. Practice user/group management on a disposable VM or container.
3. Learn `systemctl` + logs (`journalctl`) together — they're used constantly in real troubleshooting.
4. Networking + firewall basics next, since these matter a lot for deploying anything (relevant if you're heading toward cloud/DevOps work).
5. Layer in monitoring tools and shell scripting to start automating the repetitive parts.
6. LVM and advanced disk management can come later — useful but less frequently needed day-to-day.

---

*This guide favors Debian/Ubuntu and RHEL/Fedora syntax, the two most common families in production and cloud environments (AWS, GCP, Azure images). FOR more information visit : https://github.com/manaboy-07/ultimate-linux-guide*