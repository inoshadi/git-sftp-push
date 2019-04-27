#!/bin/bash
if [[ $# -eq 0 ]] ; then
    echo 'No argument supplied'
    echo 'usage: deploy.sh [usr@domain.xxx:/path/to/target/]'
    exit 1
fi
echo "staging..."
CURRDIR=`dirname $0`
$CURRDIR/sftpPush.sh
echo "push staged.."
sftp $1 < /tmp/sftpPush.txt
