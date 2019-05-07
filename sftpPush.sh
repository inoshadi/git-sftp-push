#!/bin/bash
pwd
FN_GD=/tmp/sftpPush_tmp.txt
echo '' > $FN_GD
FN_TMP=/tmp/sftpPush.txt
echo '' > $FN_TMP
git diff --name-only `git rev-parse @~` `git rev-parse @` > $FN_GD
echo "Staged file(s):"
cat $FN_GD
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
while IFS= read -r FN
do
  if test -f "${FN}"; then
    echo "put ${FN} ${FN}" >> $FN_TMP
  else 
    echo "rm ${FN}" >> $FN_TMP
  fi
done < "$FN_GD"

#printf '%s\n' "${FN}"
#sed -i -e 's/\(.*\)/\1 \1/' $FN_TMP
#sed -i -e 's/^/put /' $FN_TMP
#echo "quit" >> $FN_TMP
cat $FN_TMP

