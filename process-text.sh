#!/bin/bash
echo "
▒██   ██▒ ██▓      ██████  ██▀███  ▓█████  ███▄ ▄███▓ ▄▄▄       ██ ▄█▀▓█████  ██▀███  
▒▒ █ █ ▒░▓██▒    ▒██    ▒ ▓██ ▒ ██▒▓█   ▀ ▓██▒▀█▀ ██▒▒████▄     ██▄█▒ ▓█   ▀ ▓██ ▒ ██▒
░░  █   ░▒██░    ░ ▓██▄   ▓██ ░▄█ ▒▒███   ▓██    ▓██░▒██  ▀█▄  ▓███▄░ ▒███   ▓██ ░▄█ ▒
 ░ █ █ ▒ ▒██░      ▒   ██▒▒██▀▀█▄  ▒▓█  ▄ ▒██    ▒██ ░██▄▄▄▄██ ▓██ █▄ ▒▓█  ▄ ▒██▀▀█▄  
▒██▒ ▒██▒░██████▒▒██████▒▒░██▓ ▒██▒░▒████▒▒██▒   ░██▒ ▓█   ▓██▒▒██▒ █▄░▒████▒░██▓ ▒██▒
▒▒ ░ ░▓ ░░ ▒░▓  ░▒ ▒▓▒ ▒ ░░ ▒▓ ░▒▓░░░ ▒░ ░░ ▒░   ░  ░ ▒▒   ▓▒█░▒ ▒▒ ▓▒░░ ▒░ ░░ ▒▓ ░▒▓░
░░   ░▒ ░░ ░ ▒  ░░ ░▒  ░ ░  ░▒ ░ ▒░ ░ ░  ░░  ░      ░  ▒   ▒▒ ░░ ░▒ ▒░ ░ ░  ░  ░▒ ░ ▒░
 ░    ░    ░ ░   ░  ░  ░    ░░   ░    ░   ░      ░     ░   ▒   ░ ░░ ░    ░     ░░   ░ 
 ░    ░      ░  ░      ░     ░        ░  ░       ░         ░  ░░  ░      ░  ░   ░     
                                                                                      "

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pathToExcels="$SCRIPT_DIR/data-to-process/";

function type2CSV () {
	for file in $(find $pathToExcels -type f -name "*.xlsx"); do
		xlsx2csv $file > ${file%.xlsx}.csv
		sampleName=$(cat ${file%.xlsx}.csv  | grep "Sample name");
		trimmedSampleName=$(echo "$sampleName" | sed 's/^Sample name,,,,,,,//; s/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,$//')
		file_contents=$(cat ${file%.xlsx}.csv)
		
		echo "$file_contents" | sed '1,/Intensity(cps\/μA),,,,,/d' > ${file%.xlsx}-new.csv
		
		newCsvContents=$(cat ${file%.xlsx}-new.csv)
		echo "$newCsvContents" | sed '/3\. Sample Spectrum\,*/,/Intensity(cps\/μA),,,,,/d' > ${file%.xlsx}-new.csv
		newCsvContents=$(cat ${file%.xlsx}-new.csv)
		echo "$newCsvContents" | sed 's/,\{30,\}//g' > ${file%.xlsx}-new.csv
		newCsvContents=$(cat ${file%.xlsx}-new.csv)
		echo "$newCsvContents" | sed 's/,*Intensity(cps\/μA),*//g' > ${file%.xlsx}-new.csv
		newCsvContents=$(cat ${file%.xlsx}-new.csv)
		echo "$newCsvContents" | sed '/3\. Sample Spectrum/d' > ${file%.xlsx}-new.csv
		newCsvContents=$(cat ${file%.xlsx}-new.csv)
		echo "$newCsvContents" | sed 's/,*,\{30,\},*//g' > ${file%.xlsx}-new.csv
		newCsvContents=$(cat ${file%.xlsx}-new.csv)
		echo "$newCsvContents" | sed 's/^<<Notes>>$//g' > ${file%.xlsx}-new.csv
		newCsvContents=$(cat ${file%.xlsx}-new.csv)
		echo "$newCsvContents" | sed '/^No\.,,Component,,,,Analyzed value,,,,,Unit,,,Statistics error,,,,,L\.L\.D\.,,,L\.L\.Q\.,,,Analytical line,,,,,Condition name$/d' > ${file%.xlsx}-new.csv
		newCsvContents=$(cat ${file%.xlsx}-new.csv)
		echo "$newCsvContents" | sed '/2\. Analysis Results/d' > ${file%.xlsx}-new.csv
		newCsvContents=$(cat ${file%.xlsx}-new.csv)
		echo "$newCsvContents" | cut -d ',' -f 1-9 > ${file%.xlsx}-new.csv
		newCsvContents=$(cat ${file%.xlsx}-new.csv)
		echo "$newCsvContents" | sed 's/^[0-9]\+,,//; s/,,,,,/,/g; s/,,/,/g' > ${file%.xlsx}-new.csv		
		newCsvContents=$(cat ${file%.xlsx}-new.csv)
		echo "$newCsvContents" | sed 's/,,/,/g' > ${file%.xlsx}-new.csv
		newCsvContents=$(cat ${file%.xlsx}-new.csv)
		echo "$newCsvContents" | sed 's/(//g' > ${file%.xlsx}-new.csv
		newCsvContents=$(cat ${file%.xlsx}-new.csv)
		echo "$newCsvContents" | sed 's/)//g' > ${file%.xlsx}-new.csv
		newCsvContents=$(cat ${file%.xlsx}-new.csv)
		echo "$newCsvContents" | sed '/^$/d' > ${file%.xlsx}-new.csv
		newCsvContents=$(cat ${file%.xlsx}-new.csv)
		echo "$newCsvContents" | sed 's/,$//' > ${file%.xlsx}-new.csv
		#(this is the dumbest shit ever I know but I'm drunk and want this done in less than an hour lol)
	done
}

function type1CSV () {
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
}


##Run the php script
# Check if xlsx2csv is installed
if ! command -v php &> /dev/null
then
    echo "php is not found."
    echo "To install, run the following command (maybe): sudo apt install php"
    exit 1
fi

if [ $# -eq 0 ]; then
  echo "Please supply a type to process:"
  echo "Usage: ./nameOfScript <type#>"
  echo "Type 1 - the old ones"
  echo "Type 2 - the new ones"
  exit 1
fi

case "$1" in
    "1")
        type1CSV;
        ;;
    "2")
        type2CSV;
        ;;
    *)
        echo "Unknown command: $1"
        ;;
esac

php ./mergeCsv.php

echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣀⠤⠄⠒⠋⠉⠉⠉⠉⠉⠉⠉⠑⠒⠢⢄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⢀⡠⠖⠉⠀⠀⠀⠀⠀⠀⠀⠀⢸⠋⣑⡦⣄⠀⠀⠀⠈⠙⠢⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠴⠿⠷⠶⣶⣦⣤⣤⣀⡀⠀⠀⠀⢸⣿⡀⠉⠛⢽⢦⣀⠀⠀⠀⠀⠑⢄⣀⣀⣠⡤⢴⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠈⠙⣻⡿⠟⠒⠀⠀⢾⣙⣇⡠⠖⠋⠉⡉⠀⠀⠀⠀⠀⠈⠻⡏⠀⠀⡸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⡤⠊⠁⠀⠀⠀⠀⠀⠈⠿⠏⠀⡠⠊⢉⣉⡉⠲⢄⠀⠀⠀⠀⢹⣄⣰⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⡰⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠁⡼⠋⠉⠙⢷⣌⣣⡀⠀⠀⠚⣡⡯⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⢀⡞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠇⣸⠀⠀⣠⡀⠀⢻⣟⠓⠀⠀⢸⢿⠷⡞⠉⠒⢄⠀⠀⣀⡀⠀⠀⠀⠀
⠀⢀⡞⠀⠀⠀⠀⠀⠀⠀⣀⣤⠀⠀⠀⠀⠀⠀⢿⠀⢀⣯⡽⠀⠀⢿⡄⠀⢸⣿⣸⠀⠈⢆⠀⠈⡷⠉⢁⣈⣑⣄⠀⠀
⠀⡸⠀⠀⠀⠀⣀⣤⣶⣿⡿⠋⠀⠀⠀⠀⢀⣠⡬⢧⣸⣿⠃⠀⠀⠀⢣⣀⣾⣿⣏⡀⠀⢀⡇⠀⡇⡴⢉⣀⠤⠼⣧⠀
⢀⠇⠀⠀⣠⣾⠿⠛⠉⡟⠀⠀⠀⠀⠀⢳⣼⡋⢶⢾⡉⠓⠤⡠⠤⠒⠊⠙⣿⣿⠿⠃⠀⣸⡇⠀⢉⣇⡼⢀⡠⠤⣼⡇
⠘⠀⣠⡾⠋⠁⠀⠀⡼⠀⠀⠀⠀⠀⣴⣾⣿⣷⣌⡑⠛⠢⠄⠀⠀⢀⣀⡤⠚⠁⠀⠀⣰⡇⠹⣶⡏⠀⢹⡏⢀⣠⣼⠀
⢸⡾⠋⠀⠀⠀⠀⠀⡇⠀⠀⠀⣠⣾⡿⠟⢛⣻⠿⠛⠋⡿⠓⢛⡽⠟⠣⣄⠀⠀⠀⠀⢿⠾⡄⠙⠳⠤⣤⡭⠿⠛⠁⠀
⠀⠁⠀⠀⠀⠀⠀⢰⡇⠀⠀⣴⡿⠋⡴⠊⢁⡠⠴⠚⡏⠀⢀⡏⠀⠀⠀⠈⢏⠒⠢⠒⠉⢦⡀⠀⣰⡾⠋⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢠⡇⠀⣼⠋⠀⠀⢧⠀⠘⣿⢳⢤⣸⣦⡀⡇⠀⠀⠀⠀⢸⠓⠦⠤⠔⠊⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢇⣸⠁⠀⠀⠀⣼⣷⣤⠎⠘⢒⡇⠈⠉⢻⡄⠀⠀⢀⡞⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠘⡇⠀⠀⠀⠀⠘⢺⣶⠆⣠⠞⠁⠀⠀⢸⠱⣤⣴⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣄⣀⠀⢀⢠⣿⡾⢿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢘⣷⡿⠿⡿⠛⡿⣹⠁⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠁⣰⢁⠇⢰⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⠤⢴⠁⢠⣿⣞⣀⣼⠷⠦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠁⠸⣤⡯⠤⠟⠛⡦⠀⣀⠤⢶⡃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠞⢷⡦⠀⠀⢠⡔⢯⠁⣀⣉⣉⡠⢿⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤⠜⠓⠶⣤⣄⣀⣀⣼⡞⠛⡟⠉⠀⠀⢀⠔⠛⠓⠢⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣁⣀⡀⠀⠀⠀⠑⢄⠀⠀⢧⣼⠀⠀⠀⡴⠁⠀⠀⠀⠀⠀⠈⠳⡀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣠⠞⠁⠀⠀⠀⠉⠢⡀⠀⠀⠈⡆⢀⣾⣿⣀⣀⢸⡁⠀⠀⠀⠀⠀⠀⠀⢀⣹⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⡴⠁⠀⠀⠀⠀⠀⠀⠀⠘⡀⠀⣠⡿⠟⠁⠉⠉⠛⠛⠛⠿⠶⠶⠶⠶⠿⠛⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣥⡀⠀⠀⠀⠀⠀⢀⣀⣤⡷⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠉⠛⠻⠶⠶⠾⠛⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

|== Hey kids, it's me Sonic ===|
|==============================|
| I processed your excel       |
| spreadsheet whatchamacallits |
| to the file 'output.csv'.    |
|                              |
| Gotta go fight Dr. Robotnik  |
| now, see ya later!           |
|______________________________|
|DONT DO THE DRUGS!            |
";
