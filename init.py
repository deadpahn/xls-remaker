import pandas as pd
import os

# Path to the directory containing the .xlsx files
path = "data-to-process/"

# List all .xlsx files in the directory
files = [f for f in os.listdir(path) if f.endswith(".xlsx")]

# List to hold all DataFrames
dfs = []

# Loop through each file and extract data
for file in files:
    # Read in the file as a DataFrame
    df = pd.read_excel(os.path.join(path, file))

    # Extract relevant data
    sample_name = df.iloc[0, 0]
    data = df.iloc[1:, :]

    # Convert any numbers stored as text into actual numbers
    data = data.apply(pd.to_numeric, errors="ignore")

    # Create a new DataFrame with the extracted data
    new_df = pd.DataFrame(data.values, columns=data.columns)
    new_df.insert(0, "Sample Name", sample_name)

    # Add the new DataFrame to the list
    dfs.append(new_df)

# Concatenate all DataFrames into a single DataFrame
final_df = pd.concat(dfs)

# Sort the final DataFrame by element
final_df = final_df.sort_values(by="Element")

# Export the final DataFrame to a new .xlsx file
final_df.to_excel("output_file.xlsx", index=False)
