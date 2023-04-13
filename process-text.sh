#!/bin/bash

# Check if xlsx2csv is installed
if ! command -v xlsx2csv &> /dev/null
then
    echo "xlsx2csv is not found."
    echo "To install, run the following command: pip install xlsx2csv"
    exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pathToExcels="$SCRIPT_DIR/data-to-process/";
for file in $(find $pathToExcels -type f -name "*.xlsx"); do
	xlsx2csv $file > ${file%.xlsx}.csv
	sampleName=$(cat ${file%.xlsx}.csv  | grep "Sample name");
	trimmed=$(echo "$sampleName" | sed 's/^Sample name,,,,,,,//; s/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,$//')
	file_contents=$(cat ${file%.xlsx}.csv)
	start_pos=$(echo "$file_contents" | grep -b -o '2\. Analysis Results,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' | cut -d ':' -f 1)
	end_pos=$(echo "$file_contents" | grep -b -o '3\. Sample Spectrum,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' | cut -d ':' -f 1)
	trimmed_contents=${file_contents:$((start_pos+65)):$((end_pos - start_pos - 65))}
	trimmed_contents=$(echo "$trimmed_contents" | cut -d ',' -f 1-9)
	trimmed_contents=$(echo "$trimmed_contents" | sed 's/^[0-9]\+,,//; s/,,,,,/,/g; s/,,/,/g')
	echo "$trimmed_contents" | sed '/^$/d; s/,,/,/g; s/^,//; s/,$//; /^<<Notes>>$/,$d' > ${file%.xlsx}-new.csv
done
