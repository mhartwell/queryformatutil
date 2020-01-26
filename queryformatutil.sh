#!bin/bash -xe

#Author: Mike Hartwell
#this is a quick and dirty script to take input from a hardcoded directory and formats it into a sql friendly format ideal for pasting into the predicate for IN statements
trim() {
    local var="$*"
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   
    echo "$var"
}

IFS=$'\n'
TODAYS_DATE=$(date +'%Y-%m-%d')
INPUT_FILE="/Users/${USER}/Desktop/Project Code/scripts/queryformatter/input/input.txt"
INPUT_DIRECTORY="/Users/${USER}/Desktop/Project Code/scripts/queryformatter/input"
OUTPUT_DIRECTORY="/Users/${USER}/Desktop/Project Code/scripts/queryformatter/output"
OUTPUT_FILE="${OUTPUT_DIRECTORY}/${TODAYS_DATE}_output.txt"

echo "Configured to take input from ${INPUT_FILE}...."
echo "Checking input file...."
if [ -f "$INPUT_FILE" ]
then
	echo "Input File Exists...."
else
	echo "Input File Does Not Exist...." 
	echo "Creating Input File ....."
	touch "${INPUT_DIRECTORY}/input.txt"
	if [ $? -ne 0 ]
	then
		echo "Error creating input file ....."
		echo "Creating Directory ....."
		mkdir "${INPUT_DIRECTORY}"
		touch "${INPUT_FILE}"
		echo "Input file created ..."
		echo "Please update the input file and launch again ...."
		echo "can be found at ${INPUT_FILE}...."
		exit 1
	fi	
fi

#format each new line
echo "Reading input file .... "
while read LINE
do
	TEMPLINE=$(trim "${LINE}")
	NEWLINE+="'${TEMPLINE}',\n"
	#NEWLINE+="${TEMPLINE}"
done < "$INPUT_FILE"

#echo "This is the output: ${NEWLINE}"
#remove the last comma and a sh*tload of eschape chars on the last line
FINAL_OUTPUT=${NEWLINE%????????}
if [ $? -ne 0 ]; then
	echo "error formatting text"
	exit 1
else
	echo "Formatting text .... ";
	#echo "FINAL OUTPUT: ${FINAL_OUTPUT}"
fi
#return to the clipboard
echo -e "$FINAL_OUTPUT" >> "${OUTPUT_FILE}"
if [ $? -ne 0 ]
	then
		echo "Error writing to output file"
		exit 1
	else
		echo "Output written to ${OUTPUT_FILE}"
fi

exit 0
