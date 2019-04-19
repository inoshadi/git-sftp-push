#!/bin/bash
echo "staging..."
~/mytools/sftpPush.sh
echo "push staged.."
sftp sftpusr@example.com:/var/www/html/ < /tmp/sftpPush.txt
