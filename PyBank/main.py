
#**********************************************
#
# PyBank Homework 3/16/2019
# Harish Krishna
#
#**********************************************

import os
import csv

csvpath = "./budget_data.csv"

with open(csvpath, newline='') as csvfile:

    # CSV reader reads from current directory
    csvreader = csv.reader(csvfile, delimiter=',')

    # Read the header row first
    csv_header = next(csvreader)

    # Initialize variables
    row_count = 0
    profit_loss = 0
    current_profit_loss = 0
    total_change_in_profit = 0
    change_in_profit_dict = {}                                                    # Dictionary to hold month and changes to profit /loss
    
    # Read each row of data after the header
    for row in csvreader:
        row_count = row_count + 1                                                 # Calculate number of months
        profit_loss = profit_loss + int(row[1])                                   # Caluclate total amount of profit / loss
             
        if row_count > 1:
            change_in_profit = int(row[1]) - int(current_profit_loss)             # Calculate avg. changes in profit/loss
            total_change_in_profit = total_change_in_profit + change_in_profit    
            change_in_profit_dict.update({row[0]: change_in_profit})              # Create month and change to dictionary
            #print(change_in_profit_dict)
          
        current_profit_loss = row[1]   

# calculate min and max values of change from dictionary 
min_v = min(zip(change_in_profit_dict.values(), change_in_profit_dict.keys()))
max_v = max(zip(change_in_profit_dict.values(), change_in_profit_dict.keys()))

#Print Results
print('Financial Analysis')
print('------------------')            
print('Total number of months:', row_count)
print('Total amount of "Profit/Losses": $', profit_loss)
print('Average of the changes in "Profit/Losses":', round(total_change_in_profit / (row_count-1), 2))
print('Greatest Increase in Profits:', max_v[1], '($', max_v[0], ')')
print('Greatest Decrease in Profits:', min_v[1], '($', min_v[0], ')')

    

