#!/bin/bash
echo "staging..."
./sftpPush.sh
echo "push staged.."
sftp sftpusr@example.com:/var/www/html/ < /tmp/sftpPush.txt
