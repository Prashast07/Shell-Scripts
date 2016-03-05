if [ -e Dependency.txt ]
then
rm -f Dependency.txt
fi
red='\e[0;31m'
NC='\e[0m'
############
#read inputs
############
echo "Enter IS address(http://name:port) :"
read server
echo "Enter IS username :"
read user
echo "Enter IS Password :"
read -s password
echo "Enter Element's name to find dependency :"
read element
Flag='0'
#################################
#get initial dependency services
#################################
./getAdapterservice.sh $server $user $password $element
if [ -e error.txt ]
then
rm -f error.txt
echo -e "${red}Check inputs or server might down ${NC}"
else
echo "Initialization" >> Depedency.txt
num_connectionState=`wc -l < Depedency.txt`
while [ $num_connectionState != 0 ]
do
if [ $num_connectionState != 0 ]
then
./getDependency.sh $server $user $password
cp Depedency.txt adapter.txt
num_connectionState=`wc -l < Depedency.txt`
else
break
fi
done
sed -e "/adapter/Id" Final_Depedency.txt >> depedency.txt
sort -u depedency.txt >> Dependency.txt
rm Depedency.txt adapter.txt Final_Depedency.txt depedency.txt
fi