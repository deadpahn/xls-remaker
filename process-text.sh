#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pathToExcels="$SCRIPT_DIR/data-to-process/";
echo "The script directory is: $SCRIPT_DIR"
for file in $(find $pathToExcels -type f -name "*.xlsx"); do
  echo "Processing $file"
  xlsx2csv $file > ${file%.xlsx}.csv
  echo "Reading ${file%.xlsx}.csv"
  sampleName=$(cat ${file%.xlsx}.csv  | grep "Sample name");
  echo $sampleName;
  trimmed=$(echo "$sampleName" | sed 's/^Sample name,,,,,,,//; s/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,$//')
  echo "$trimmed"
done

