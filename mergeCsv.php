<?
$folderWithCsvs = "./data-to-process/";
$arrayOfArrays = array();

foreachFileIn

function storeCsvFileIntoArray($fileName): array
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
