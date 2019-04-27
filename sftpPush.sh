#!/bin/bash
pwd
FN_TMP=/tmp/sftpPush.txt
echo '' > $FN_TMP
git diff --name-only `git rev-parse @~` `git rev-parse @` > $FN_TMP
sed -i -e 's/\(.*\)/\1 \1/' $FN_TMP
sed -i -e 's/^/put /' $FN_TMP
echo "quit" >> $FN_TMP
cat $FN_TMP

