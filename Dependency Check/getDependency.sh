#!/bin/bash
server="${1}"
user="${2}"
password="${3}"

declare -a ARR_connectionState
val_connectionState=`cat adapter.txt`
ARR_connectionState=( $val_connectionState )
num_connectionState=`wc -l < adapter.txt`

for ((j=0;j<$num_connectionState;j++))
do
wget --user=$user --password=$password $server/invoke/wm.server.ns.dependency/getDependent?node=${ARR_connectionState[j]} > /dev/null 2>&1
######################
#remove HTML Tags
######################
sed -n '/^$/!{s/<[^>]*>//g;p;}' getDependent?node=${ARR_connectionState[j]} >> ${ARR_connectionState[j]}.txt
rm -f getDependent?node=${ARR_connectionState[j]}
######################
#remove blanks spaces
######################
sed -i '/^[[:space:]]*$/d' ${ARR_connectionState[j]}.txt
awk '{a[NR]=$0}$0~/LOCK_STATUS/{printf("%s\n",a[NR-1])}' ${ARR_connectionState[j]}.txt > ${ARR_connectionState[j]}_temp.txt
rm -f ${ARR_connectionState[j]}.txt
mv ${ARR_connectionState[j]}_temp.txt ${ARR_connectionState[j]}.txt
################################################################################
#tokenize to get complete service name alone only if file size is greater than 0
################################################################################
if [ `ls -l ${ARR_connectionState[j]}.txt | awk '{print $5}'` -gt 0 ]
then
for register_adapter in `cat ${ARR_connectionState[j]}.txt`
do
var=$(echo $register_adapter | awk -F"/" '{print $2}') 
set -- $var
echo $1 >> ${ARR_connectionState[j]}_temp.txt
done
mv ${ARR_connectionState[j]}_temp.txt ${ARR_connectionState[j]}.txt
fi
##########################################
#get final dependency when dependency is 0
##########################################
if [ `ls -l ${ARR_connectionState[j]}.txt | awk '{print $5}'` -eq 0 ]
then
echo "${ARR_connectionState[j]}" >> fin_Depedency.txt
sort -u fin_Depedency.txt >> Final_Depedency.txt
rm -f fin_Depedency.txt
fi
##############################
#To remove same data in output
##############################
sed '/'${ARR_connectionState[j]}'/d' ./${ARR_connectionState[j]}.txt > ${ARR_connectionState[j]}_temp.txt
mv ${ARR_connectionState[j]}_temp.txt ${ARR_connectionState[j]}.txt
cat ${ARR_connectionState[j]}.txt >> temp_Depedency.txt
rm -f ${ARR_connectionState[j]}.txt
done
######################
#remove duplicate data
######################
sort -u temp_Depedency.txt > Depedency.txt
rm -f temp_Depedency.txt
