#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo 'Required 2 arguments supplied for generating sftp command'
    echo 'usage: sftpPush.sh [tmp_filename_1] [tmp_filename_2]'
    exit 1
fi
pwd

FN_GD=$1
echo '' > $FN_GD
FN_TMP=$2
echo '' > $FN_TMP
FN_TMP2="${FN_TMP}2"

if [ `git rev-list --count HEAD` == 1 ]; then
    echo "Currently you've got only one commit available"
    git log --oneline --name-only `git rev-parse @` > $FN_TMP  
    sed '1d' $FN_TMP > $FN_GD
    echo '' > $FN_TMP
    
else
    git diff --name-only `git rev-parse @~` `git rev-parse @` > $FN_TMP
    cat $FN_TMP > $FN_GD
    echo '' > $FN_TMP
fi

echo "Staged file(s):"
cat $FN_GD
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
LIN=`wc -l $FN_GD | cut -f 1 -d " "`

echo "Processing ${LIN} line(s) of $FN_GD....."
while IFS= read -r FN
do
  if test -f "${FN}"; then
    git log --name-only --oneline --follow "$FN" >$FN_TMP2
    sed -i '1~2d' $FN_TMP2
    FNB=`sed '2!d' $FN_TMP2`
    
    FNA=`sed '1!d' $FN_TMP2`
    if [ "$FNB" != "" ]; then
        if [ "$FNB" != "$FNA" ] ; then

            if test -f "${FNB}"; then
                echo "";
            else
                echo "File has been renamed from $FNB to $FNA"
                echo "rm ${FNB}" >> $FN_TMP
                printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
            fi
            echo "put ${FNA} ${FNA}" >> $FN_TMP
            
        else 
            echo "put ${FN} ${FN}" >> $FN_TMP
        fi
    else 
        echo "put ${FN} ${FN}" >> $FN_TMP
    fi
  else
    echo "File has been deleted: $FN"
    echo "rm ${FN}" >> $FN_TMP
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
  fi
  
done < "$FN_GD"
echo "SFTP Commands generated: "
cat $FN_TMP

