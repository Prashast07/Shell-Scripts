#####################################################################################################
# The purpose of the script is to compare the differences in flow.xml files of two different versions
#####################################################################################################

echo "============================================="
echo "Version Comparison"
echo "============================================="
echo "Enter Package name (Lower Version)"
read lowerVersion
echo "Enter Package name (Higher Version)"
read higherVersion

#Extracting the packages and saving it to different folders (LowerVersion & HigherVersion)
##########################################################################################
unzip $lowerVersion -d/app/webmcore1/Test/LowerVersion
unzip $higherVersion -d/app/webmcore1/Test/HigherVersion

#Moving all the paths of services lower & higher versions in lowerVersionServiceList.txt & higherVersionServiceList.txt text files
###################################################################################################################################
cd LowerVersion
find . -type f -exec echo {} \; >> lowerVersionServiceList.txt
mv lowerVersionServiceList.txt /app/webmcore1/Test
cd ../HigherVersion
find . -type f -exec echo {} \; >> higherVersionServiceList.txt
mv higherVersionServiceList.txt /app/webmcore1/Test
cd ..

#Moving node.ndf paths in lowerVersionFlowList.txt & higherVersionFlowList.txt text files
#########################################################################################
grep 'node.ndf$' /app/webmcore1/Test/lowerVersionServiceList.txt  >> lowerVersionFlowList.txt
grep 'node.ndf$' /app/webmcore1/Test/higherVersionServiceList.txt >> higherVersionFlowList.txt
sed 's/.//' lowerVersionFlowList.txt >lowerVersionFinalFlowList.txt
sed 's/.//' higherVersionFlowList.txt >higherVersionFinalFlowList.txt

#Array declaration and comparing the difference of flow.xml files in two different versions
#############################################################################################
declare -a ARR1
declare -a ARR2
list1=`cat lowerVersionFinalFlowList.txt`
list2=`cat higherVersionFinalFlowList.txt`
ARR1=( $list1 )
ARR2=( $list2 )
num1=`wc -w lowerVersionFinalFlowList.txt | sed 's/lowerVersionFinalFlowList.txt//g'`   # Counting the number of lines in lowerVersionFinalFlowList.txt 
num2=`wc -w higherVersionFinalFlowList.txt | sed 's/higherVersionFinalFlowList.txt//g'` # Counting the number of lines in higherVersionFinalFlowList.txt
mkdir VersionDifference
for ((i=0;i<$num1;i++))
	do
		for ((j=0;j<$num2;j++))
			do 
				if [ "${ARR1[i]}" == "${ARR2[j]}" ];then
					x=${ARR1[i]}
					x=${x%/node.ndf}    	#remove node.ndf
					x=${x##*/can}		#remove everything before svc
					s=/app/webmcore1/Test/LowerVersion"${ARR1[i]}"   #Storing the complete file path of LowerVersion  in s
					r=/app/webmcore1/Test/HigherVersion"${ARR2[j]}"	#Storing the complete file path of HigherVersion in r
					diff $s $r > /app/webmcore1/Test/VersionDifference/$x.txt
				fi
			done
	done
#Removing unwanted folders
######################################
rm lowerVersionServiceList.txt higherVersionServiceList.txt lowerVersionFlowList.txt higherVersionFlowList.txt lowerVersionFinalFlowList.txt higherVersionFinalFlowList.txt 
