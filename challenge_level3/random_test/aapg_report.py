import re
import pandas as pd
from datetime import datetime
from datetime import date
import yaml
from yaml.loader import SafeLoader
import os

def get_number_instructions(file):
    with open(file) as f:
        data = yaml.load(f, Loader=SafeLoader)
        total_instructions = data['general']['total_instructions']

    return total_instructions

def find_buggy_instructions_from_diff(file):

    file1 = open(file, 'r')
    Lines = file1.readlines()
    file1.close()

    sim1 = []
    sim2 = []

    for line in Lines:
        instr = line.strip()
        if line[0] == "<":
            sim1.append([instr[6:14], instr[18:26]])
        if line[0] == ">":
            sim2.append([instr[6:14], instr[18:26]])

    sim1_pd = pd.DataFrame(sim1, columns = ["pc", "instr"])
    sim2_pd = pd.DataFrame(sim2, columns = ["pc", "instr"])

    # Merge the two DataFrames based on the index so that we can compare them row-wise
    merged_df = pd.merge(sim1_pd, sim2_pd, left_index=True, right_index=True, suffixes=('_df1', '_df2'))
    # Create a new column to indicate whether the values in the 'column_to_compare' are the same or different
    merged_df['comparison'] = merged_df.apply(lambda row: True if row['pc' + '_df1'] == row['pc' + '_df2'] else False, axis=1)


    sim1_pd['pc match'] = merged_df['comparison']
    
    return sim1_pd

def split_instr(input_string):
    # Split the input string at spaces and commas
    split_result = input_string.split(' ')  # Split at spaces
    split_result = [item.split(',') for item in split_result]  # Split each item further at commas

    # Flatten the nested lists to get the final result
    final_result = [item for sublist in split_result for item in sublist]

    return final_result

def find_buggy_asm_from_dump(file_path, search_strings):
    matching_lines = []

    with open(file_path, 'r') as file:
        for line in file:
            if any(search_str in line for search_str in search_strings):
                matching_lines.append(split_instr(line.strip()[29:].replace('\t', ' '))[0:3])

    return pd.DataFrame(matching_lines, columns = ["instr", "rd", "op1"])

def get_immediate_subdirectories(a_dir):
    return [name for name in os.listdir(a_dir)
            if os.path.isdir(os.path.join(a_dir, name))]

def main():
    folder = os.path.join(os.getcwd(), "dump")
    types = get_immediate_subdirectories(folder)

    overview_df = pd.DataFrame(columns = ["test_name", "pc_match", "no_of_instructions"])

    types_data = {}

    for sub_type in types:
        
        sub_type_folder = os.path.join(folder, sub_type)
        print(sub_type_folder)
        
        sub_type_folder_tests = get_immediate_subdirectories(sub_type_folder)
        print(sub_type_folder_tests)
        
        print('\n')
        
        sub_type_folder_tests_data = {}
        
        for test in sub_type_folder_tests:
            
            test_dict = {}
            
            print(test)
            
            test_folder = os.path.join(sub_type_folder, test)
            
            print(test_folder)
            
            overview_dict = {}        
            
            overview_dict["test_name"] = sub_type + "_" + test
            overview_dict["no_of_instructions"] = get_number_instructions(os.path.join(os.getcwd(), "yaml_files", "rv32i_"+test+".yaml"))
            
            buggy_hex = find_buggy_instructions_from_diff(os.path.join(test_folder, "diff.dump"))
            
            if len(buggy_hex["instr"][buggy_hex["pc match"]==False]) == 0:
                pc_match = True
            else:
                pc_match = False
            overview_dict["pc_match"] = pc_match
            
            print("Overview", overview_dict)
            
            buggy_asm = find_buggy_asm_from_dump(os.path.join(test_folder,"test.disass"),
                                                list(buggy_hex["instr"][buggy_hex["pc match"]==True]))
            
            bug_count_pd = pd.DataFrame(buggy_asm["instr"].value_counts()).reset_index(inplace=False)
            
            sub_type_folder_tests_data[test] = bug_count_pd
            
            overview_dict_df = pd.DataFrame([overview_dict])
            overview_df = pd.concat([overview_df, overview_dict_df], ignore_index=True)

            print('\n')
        
        # Concatenate all DataFrames into a single DataFrame
        temp_df = pd.concat(sub_type_folder_tests_data.values()).reset_index(drop=True)

        # Initialize the 'Source' column to an empty string
        temp_df['source'] = ''

        # Fill the 'Source' column with the actual source DataFrame names
        for source_name, source_df in sub_type_folder_tests_data.items():
            indices = temp_df['instr'].isin(source_df['instr'])
            temp_df.loc[indices, 'source'] += source_name + ', '

        # Remove the trailing comma from the 'Source' column
        temp_df['source'] = temp_df['source'].str.rstrip(', ')

        # Group by 'Item' and calculate the sum of 'Count' for each item
        grouped_df = temp_df.groupby('instr', as_index=False).agg({'count': 'sum', 'source': 'first'})
        
        print(sub_type)
        types_data[sub_type] = grouped_df
        
        print('\n***************************************************\n')


    # Create an ExcelWriter object and specify the file name
    output_file = str(date.today()).replace("-", "_") + "aapg_report.xlsx"
    writer = pd.ExcelWriter(output_file, engine='openpyxl')

    # Save each DataFrame as a separate sheet in the Excel file
    overview_df.to_excel(writer, sheet_name='overview', index=False)
    types_data["with_hazard"].to_excel(writer, sheet_name='with_hazards', index=False)
    types_data["without_hazard"].to_excel(writer, sheet_name='without_hazards', index=False)
    types_data["default"].to_excel(writer, sheet_name='default', index=False)

    # Save the changes to the Excel file
    writer.close()

if __name__ == '__main__':
    main()