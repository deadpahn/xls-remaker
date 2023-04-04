import openpyxl
# Open the Excel file
workbook = openpyxl.load_workbook('data-to-process/DATA-01.xlsx')

# Select the worksheet
worksheet = workbook.active

# Get the value in the 21st column of the 10th row
value = worksheet.cell(row=1, column=1).value

# Print the value
print(value)