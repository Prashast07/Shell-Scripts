#!/bin/bash
server="${1}"
user="${2}"
password="${3}"
element="${4}"
wget --user=$user --password=$password $server/invoke/wm.server.ns.dependency/getDependent?node=$element > /dev/null 2>&1
if [ $? -eq "0" ]
then
#remove HTML Tags
sed -n '/^$/!{s/<[^>]*>//g;p;}' getDependent?node=$element >> listRegisteredAdapters.txt
rm -f getDependent?node=$element
#remove blanks spaces
sed -i '/^[[:space:]]*$/d' listRegisteredAdapters.txt
awk '{a[NR]=$0}$0~/LOCK_STATUS/{printf("%s\n",a[NR-1])}' listRegisteredAdapters.txt > RegisteredAdapters.txt
rm -f listRegisteredAdapters.txt
######################################
#tokenize to get complete service name
######################################
for register_adapter in `cat RegisteredAdapters.txt`
do
var=$(echo $register_adapter | awk -F"/" '{print $2}') 
set -- $var
echo $1 >> adapter.txt
done
rm -f RegisteredAdapters.txt
else
touch error.txt
exit
fi