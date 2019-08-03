#!/bin/bash
if [[ $# -eq 0 ]] ; then
    echo 'No argument supplied for deployment'
    echo 'usage: deploy.sh [usr@domain.xxx:/path/to/target/]'
    exit 1
fi
echo "staging..."
CURRDIR=`dirname $0`
FN_GD="/tmp/sftpPush_tmp.$RANDOM"
echo '' > $FN_GD
FN_TMP="/tmp/sftpPush.$RANDOM"
echo '' > $FN_TMP
$CURRDIR/sftpPush.sh "$FN_GD" "$FN_TMP"
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
sed -r '/^\s*$/d' "$FN_TMP" > $FN_GD
LIN=`wc -l $FN_GD | cut -f 1 -d " "`
echo "Provide your sftp password to executing $LIN line(s) of command to: $1"
echo "or (Ctrl + c) to abort"
sftp $1 < "$FN_GD"
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
echo "Removing files: $FN_GD and $FN_TMP .."
rm -f $FN_GD
rm -f $FN_TMP
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
