These are solid notes. The main improvements I'd make are:

- Organize them into sections.
- Correct a few technical inaccuracies.
- Add the "why" behind each command (this is what interviewers often ask).
- Include best practices that cloud engineers use in production.

---

# OpenSSH & Bash Scripting Notes (Cloud Engineering)

---

# Why SSH is Important

SSH (Secure Shell) is one of the most important tools for cloud engineers.

Whenever you launch a Linux virtual machine (AWS EC2, Azure VM, DigitalOcean, etc.), you normally manage it remotely using SSH.

SSH provides:

- Secure remote login
- Secure command execution
- File transfer (SCP/SFTP)
- Port forwarding
- Tunneling
- Authentication using passwords or SSH keys

---

# Lesson 1 - Bash Scripting Basics

## Making a script executable

Every shell script needs execute permission before it can run.

```bash
chmod +x script.sh
```

`chmod`

> Changes file permissions.

`+x`

> Adds execute permission.

---

## Running a script

```bash
./script.sh
```

Example

```bash
./backup.sh
```

`./`

means

> Run the executable located in the current directory.

Without `./`, Linux searches your PATH instead.

---

## Script execution order

Bash executes commands **line by line (top to bottom).**

Example

```bash
echo "Hello"

mkdir Test

cd Test

touch file.txt
```

Each command executes after the previous one unless:

- &&
- ||
- &
- background jobs
- loops
- functions

are used.

---

# Lesson 2 — SSH Basics

## Connecting to a server

Basic syntax

```bash
ssh username@ip-address
```

Example

```bash
ssh ubuntu@54.82.10.15
```

or

```bash
ssh ec2-user@ec2-54-82-10-15.compute.amazonaws.com
```

You may also connect using a DNS name.

```bash
ssh user@example.com
```

Requirements

- OpenSSH Client installed
- Server running OpenSSH Server
- Network access
- Correct username
- Port open (default 22)

---

# SSH Config File

Instead of remembering IP addresses, usernames and ports, SSH can store them.

Location

```text
~/.ssh/config
```

Example

```text
Host myserver

    HostName test.rebex.net
    User demo
    Port 22
```

Now simply connect with

```bash
ssh myserver
```

instead of

```bash
ssh demo@test.rebex.net
```

---

## Multiple Servers

You can configure as many hosts as you like.

Example

```text
Host production

    HostName 54.10.22.8
    User ubuntu
    Port 22

Host staging

    HostName 54.12.18.99
    User ubuntu
    Port 2222

Host testing

    HostName test.rebex.net
    User demo
```

Then simply run

```bash
ssh production

ssh staging

ssh testing
```

This is much easier than remembering IP addresses.

---

# Lesson 3 — SSH Keys

## Why SSH Keys?

Passwords:

❌ Can be guessed

❌ Can be brute-forced

❌ Must be typed repeatedly

SSH Keys:

✅ Much more secure

✅ Faster authentication

✅ Used by cloud providers

✅ Required by many production servers

---

## Public vs Private Key

Generating a key creates two files.

Example

```text
id_rsa

id_rsa.pub
```

or

```text
id_ed25519

id_ed25519.pub
```

### Private Key

Keep secret.

Never:

- Email it
- Upload it
- Commit it to GitHub
- Share it

If someone gets your private key, they can authenticate as you.

---

### Public Key

Safe to share.

This is copied onto remote servers.

---

## Generating SSH Keys

Traditional RSA

```bash
ssh-keygen
```

Modern (recommended)

```bash
ssh-keygen -t ed25519
```

You will be asked:

- File location
- Passphrase (optional but recommended)

---

# How SSH Key Authentication Works

Client

```
Private Key
```

↓

Server

```
Public Key
```

↓

Server verifies that the private key matches the stored public key.

If they match:

✅ Login succeeds.

---

# Manual Public Key Installation

Display your public key

```bash
cat ~/.ssh/id_ed25519.pub
```

On the server

```bash
mkdir -p ~/.ssh

nano ~/.ssh/authorized_keys
```

Paste the public key.

Save.

Now authentication uses your key.

You may store multiple public keys in `authorized_keys`, one per line.

---

# Easier Method — ssh-copy-id

Instead of manually copying the key:

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@server-ip
```

Options

`-i`

Specify the public key file.

This command automatically appends your public key to the server's `authorized_keys` file.

Verify

```bash
cat ~/.ssh/authorized_keys
```

---

# Lesson 4 — Managing Multiple SSH Keys

Different clients or projects should have separate SSH keys.

Example

```bash
ssh-keygen -t ed25519 -C "acme"
```

`-C`

Adds a comment (usually an email or project name).

Save as

```text
~/.ssh/acme_id_ed25519
```

Now use

```bash
ssh -i ~/.ssh/acme_id_ed25519 root@server-ip
```

The `-i` flag tells SSH which private key to use.

---

# SSH Agent

Typing a passphrase repeatedly is inconvenient.

SSH Agent stores decrypted keys in memory.

---

## Check if ssh-agent is running

```bash
ps aux | grep ssh-agent
```

---

## Start ssh-agent

```bash
eval "$(ssh-agent -s)"
```

---

## Add a key

```bash
ssh-add ~/.ssh/acme_id_ed25519
```

Enter the passphrase once.

Future SSH connections won't ask again during that login session.

List cached keys

```bash
ssh-add -l
```

---

# Lesson 5 — OpenSSH Server

So far we've been using the **SSH Client**.

Servers run the **OpenSSH Server**.

Check status

```bash
systemctl status sshd
```

(Some distributions use `ssh` instead of `sshd`.)

---

## SSH Configuration

Location

```text
/etc/ssh/sshd_config
```

Restart after changes

```bash
sudo systemctl restart sshd
```

---

# Important SSH Configuration Options

## Change Default Port

Default

```text
Port 22
```

Can change to

```text
Port 2222
```

Then connect with

```bash
ssh -p 2222 user@server-ip
```

Changing the port reduces automated attacks but is **not** a substitute for proper security.

---

## Disable Root Login

```text
PermitRootLogin no
```

Recommended.

Instead:

- Login as a normal user.
- Use

```bash
sudo
```

when administrative access is needed.

---

## Disable Password Authentication

```text
PasswordAuthentication no
```

Only disable passwords **after** confirming SSH key authentication works, otherwise you may lock yourself out.

---

# SSH Host Keys

Inside

```text
/etc/ssh/
```

you'll see files like:

```text
ssh_host_ed25519_key

ssh_host_rsa_key
```

These are **host keys**, used to identify the server to clients.

Do **not** copy the same host keys to multiple cloned servers, or SSH clients may warn of a potential man-in-the-middle attack.

---

# Best Practice: Test Before Closing Your Session

Whenever you change SSH settings:

1. Keep your current SSH session open.
2. Open a second terminal.
3. Test the new configuration.
4. Only close the original session after confirming the new one works.

This prevents accidentally locking yourself out of the server.

---

# Lesson 6 — Troubleshooting SSH

## 1. Check Network Connectivity

Ensure:

- SSH client is installed.
- Server is reachable.
- Port 22 (or your custom port) is open.
- Security groups, firewalls, or network ACLs allow SSH traffic.
- The ISP or local firewall is not blocking the port.

---

## 2. Check File Permissions

SSH is strict about permissions.

View them:

```bash
ls -la ~/.ssh
```

Recommended permissions:

```text
~/.ssh              700

authorized_keys     600

private key         600

public key          644
```

Incorrect permissions may cause SSH to ignore your keys.

---

## 3. View Authentication Logs

Traditional log file

```bash
tail -f /var/log/auth.log
```

(RHEL-based systems may use `/var/log/secure`.)

---

## 4. Using journalctl (Modern Method)

Show SSH logs

```bash
journalctl -u ssh
```

or

```bash
journalctl -u sshd
```

Follow logs live

```bash
journalctl -fu ssh
```

or

```bash
journalctl -fu sshd
```

This is the preferred method on systems using `systemd`.

---

# Cloud Engineering Best Practices

- Always use **Ed25519** keys instead of RSA for new deployments.
- Protect private keys with a strong passphrase.
- Never upload private keys to GitHub or share them.
- Disable password authentication after confirming key-based login works.
- Disable direct root login (`PermitRootLogin no`) and use `sudo`.
- Use a separate SSH key for different clients or environments.
- Keep your `~/.ssh/config` organized to simplify connections.
- Always test SSH configuration changes in a new terminal before closing your current session.
- Regularly review and remove unused keys from `authorized_keys`.

---

# Commands Summary

| Command                     | Purpose                          |
| --------------------------- | -------------------------------- |
| `chmod +x script.sh`        | Make a script executable         |
| `./script.sh`               | Run a script                     |
| `ssh user@host`             | Connect to a remote server       |
| `ssh -p 2222 user@host`     | Connect using a custom port      |
| `ssh-keygen -t ed25519`     | Generate a modern SSH key pair   |
| `ssh-copy-id user@host`     | Copy your public key to a server |
| `ssh-add keyfile`           | Add a key to the SSH agent       |
| `ssh-add -l`                | List cached keys                 |
| `systemctl status sshd`     | Check SSH server status          |
| `systemctl restart sshd`    | Restart the SSH service          |
| `journalctl -u sshd`        | View SSH service logs            |
| `tail -f /var/log/auth.log` | Monitor SSH authentication logs  |

These notes now follow a progression from basic scripting → SSH fundamentals → key-based authentication → server configuration → troubleshooting → production best practices, which is the same flow you'll encounter in cloud engineering roles and certifications like AWS SysOps, AWS Solutions Architect, or Linux administration.
