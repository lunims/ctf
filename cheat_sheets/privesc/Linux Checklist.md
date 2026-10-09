**Prints the environment variables available to current shell/process**
```
env
```

**list what user is allowed to do with `sudo`**
```
sudo -l
```

**SUID**
```bash
find / -type f -perm -04000 -ls 2>/dev/null
```

**Capabilities**
```
getcap -r / 2>/dev/null
```