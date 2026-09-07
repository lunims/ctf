### Scanning
```
Starting Nmap 7.99 ( https://nmap.org ) at 2026-08-21 11:41 +0200
Nmap scan report for 10.129.48.120
Host is up (0.028s latency).
Not shown: 998 closed tcp ports (reset)
PORT     STATE SERVICE VERSION
80/tcp   open  http    Apache httpd 2.4.18 ((Ubuntu))
|_http-title: Site doesn't have a title (text/html).
|_http-server-header: Apache/2.4.18 (Ubuntu)
2222/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.2 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 c4:f8:ad:e8:f8:04:77:de:cf:15:0d:63:0a:18:7e:49 (RSA)
|   256 22:8f:b1:97:bf:0f:17:08:fc:7e:2c:8f:e9:77:3a:48 (ECDSA)
|_  256 e6:ac:27:a3:b5:a9:f1:12:3c:34:a5:5d:5b:eb:3d:e9 (ED25519)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 8.53 seconds

```

--> Apache/2.4.18 (Ubuntu)
### Directories and Enumeration
```

        /'___\  /'___\           /'___\       
       /\ \__/ /\ \__/  __  __  /\ \__/       
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\      
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/      
         \ \_\   \ \_\  \ \____/  \ \_\       
          \/_/    \/_/   \/___/    \/_/       

       v2.1.0-dev
________________________________________________

 :: Method           : GET
 :: URL              : http://10.129.48.120/FUZZ
 :: Wordlist         : FUZZ: /usr/share/wordlists/seclists/Discovery/Web-Content/common.txt
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200-299,301,302,307,401,403,405,500
________________________________________________

.htpasswd               [Status: 403, Size: 297, Words: 22, Lines: 12, Duration: 30ms]
.hta                    [Status: 403, Size: 292, Words: 22, Lines: 12, Duration: 32ms]
.htaccess               [Status: 403, Size: 297, Words: 22, Lines: 12, Duration: 32ms]
cgi-bin/                [Status: 403, Size: 296, Words: 22, Lines: 12, Duration: 29ms]
index.html              [Status: 200, Size: 137, Words: 9, Lines: 10, Duration: 25ms]
server-status           [Status: 403, Size: 301, Words: 22, Lines: 12, Duration: 21ms]
:: Progress: [4750/4750] :: Job [1/1] :: 1526 req/sec :: Duration: [0:00:03] :: Errors: 0 ::

```

```
ffuf -u "http://$IP/cgi-bin/FUZZ" -w /usr/share/wordlists/seclists/Discovery/Web-Content/common.txt -e .js,.php,.py,.rb,.sh

        /'___\  /'___\           /'___\       
       /\ \__/ /\ \__/  __  __  /\ \__/       
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\      
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/      
         \ \_\   \ \_\  \ \____/  \ \_\       
          \/_/    \/_/   \/___/    \/_/       

       v2.1.0-dev
________________________________________________

 :: Method           : GET
 :: URL              : http://10.129.48.120/cgi-bin/FUZZ
 :: Wordlist         : FUZZ: /usr/share/wordlists/seclists/Discovery/Web-Content/common.txt
 :: Extensions       : .js .php .py .rb .sh 
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200-299,301,302,307,401,403,405,500
________________________________________________

.hta.php                [Status: 403, Size: 304, Words: 22, Lines: 12, Duration: 21ms]
.hta.js                 [Status: 403, Size: 303, Words: 22, Lines: 12, Duration: 21ms]
.hta.py                 [Status: 403, Size: 303, Words: 22, Lines: 12, Duration: 21ms]
.hta.sh                 [Status: 403, Size: 303, Words: 22, Lines: 12, Duration: 21ms]
.hta                    [Status: 403, Size: 300, Words: 22, Lines: 12, Duration: 21ms]
.hta.rb                 [Status: 403, Size: 303, Words: 22, Lines: 12, Duration: 21ms]
.htaccess               [Status: 403, Size: 305, Words: 22, Lines: 12, Duration: 21ms]
.htaccess.js            [Status: 403, Size: 308, Words: 22, Lines: 12, Duration: 21ms]
.htaccess.php           [Status: 403, Size: 309, Words: 22, Lines: 12, Duration: 22ms]
.htaccess.sh            [Status: 403, Size: 308, Words: 22, Lines: 12, Duration: 22ms]
.htpasswd.php           [Status: 403, Size: 309, Words: 22, Lines: 12, Duration: 22ms]
.htaccess.py            [Status: 403, Size: 308, Words: 22, Lines: 12, Duration: 22ms]
.htaccess.rb            [Status: 403, Size: 308, Words: 22, Lines: 12, Duration: 22ms]
.htpasswd.py            [Status: 403, Size: 308, Words: 22, Lines: 12, Duration: 22ms]
.htpasswd.rb            [Status: 403, Size: 308, Words: 22, Lines: 12, Duration: 22ms]
.htpasswd.sh            [Status: 403, Size: 308, Words: 22, Lines: 12, Duration: 22ms]
.htpasswd.js            [Status: 403, Size: 308, Words: 22, Lines: 12, Duration: 23ms]
.htpasswd               [Status: 403, Size: 305, Words: 22, Lines: 12, Duration: 23ms]
user.sh                 [Status: 200, Size: 118, Words: 19, Lines: 8, Duration: 30ms]
:: Progress: [28500/28500] :: Job [1/1] :: 1587 req/sec :: Duration: [0:00:17] :: Errors: 0 ::

```