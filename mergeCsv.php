<?php	
$files = buildStorageArray();
mergeArrayToCsv($files);

function mergeArrayToCsv ($files)
{

// Initialize an empty array to hold the combined data
$combined_data = array();
$file_names = getFileNames();
// Loop through each input file
foreach ($file_names as $file_name) {
    // Open the input file
    $file = fopen($file_name, 'r');

    // Loop through each row in the input file
    while (($row = fgetcsv($file)) !== false) {
        // Get the "Component" and "Analyzed value" for this row
        $component = $row[0];
        $value = $row[1];

        // If we haven't seen this component before, add a new array for it
        if (!isset($combined_data[$component])) {
            $combined_data[$component] = array();
        }

        // Add the value for this CSV file to the array for this component
        $combined_data[$component][$file_name] = $value;
    }

    // Close the input file
    fclose($file);
}

// Open the output file for writing
$output_file = fopen('output.csv', 'w');

// Write the header row for the output file
$header_row = array_merge(array('Component'), $file_names);
fputcsv($output_file, $header_row);

// Loop through each component in the combined data and write a row for it to the output file
foreach ($combined_data as $component => $values) {
    // Create an array to hold the values for this row
    $row_values = array($component);

    // Loop through each CSV file and add its value to the row
    foreach ($file_names as $file_name) {
        if (isset($values[$file_name])) {
            $row_values[] = $values[$file_name];
        } else {
            $row_values[] = '';
        }
    }

    // Write the row to the output file
    fputcsv($output_file, $row_values);
}

// Close the output file
fclose($output_file);
	
}


function buildStorageArray ()
{
	$dir = "./data-to-process/";
	$file_list = scandir($dir); // Get a list of all the files in the directory
	$data = array(); // Initialize an empty array to store the CSV data
	// Loop through each file in the directory
	foreach ($file_list as $filename) {
	  // Only load files with a .csv extension
	  if (substr($filename, -8) == "-new.csv") {
		// Load the CSV file into an array
		$csv_data = array_map('str_getcsv', file($dir.'/'.$filename));		
		
		foreach($csv_data as $row) {
			$arrContents[$row[0]] = $row[1];		
			$csvFiles[$filename] = $arrContents;
		}		
	  }
	}
	return $csvFiles;
}

function getFileNames ()
{
	$dir = "./data-to-process/";
	$file_list = scandir($dir); // Get a list of all the files in the directory
	$data = array(); // Initialize an empty array to store the CSV data
	$arrCsvFiles = array();
	
	// Loop through each file in the directory
	foreach ($file_list as $filename) {
	  // Only load files with a .csv extension
	  if (substr($filename, -8) == "-new.csv") {
			$arrCsvFiles[] = $dir . $filename;
	  }
	}
	return $arrCsvFiles;
}


function storeCsvFileIntoArray()
{
    $file = file_get_contents($fileName, true);
    $lines = explode(PHP_EOL, $file);

    foreach ($lines as $line) {
        $rowData = explode(',', $line);
        $items[] = array(
            'component' => $buffer[0],
            'anal-value' => $buffer[1],
        );
    }
    return $items;
}
?>
