
#**********************************************
#
# PyPoll Homework 3/16/2019
# Harish Krishna
#
#**********************************************

import os
import csv

csvpath = "./election_data.csv"
list_of_candidates = {}
vote_count_candidate = {}
hold_candidate = ""

with open(csvpath, newline='') as csvfile:

    # CSV reader reads from current directory
    csvreader = csv.reader(csvfile, delimiter=',')

    # Read the header row first
    csv_header = next(csvreader)

    # Initialize variables
    row_count = 0
    
    # Read each row of data after the header
    for row in csvreader:
        row_count = row_count + 1  
        candidate = row[2]
        county = row[1]
        number_votes = row[0]
       
        if candidate == hold_candidate:
            continue
        else:
            list_of_candidates.update({candidate: 0}) 
        
        hold_candidate = candidate
        
print('Election Analysis')
print('------------------')            
print('Total number of votes:', row_count)
print('------------------')  

with open(csvpath, newline='') as csvfile:

    # CSV reader reads from current directory
    csvreader = csv.reader(csvfile, delimiter=',')

    # Read the header row first
    csv_header = next(csvreader)

    # Initialize variables
    row_count1 = 0

    for row1 in csvreader:
        row_count1 = row_count1 + 1 
        candidate1 = row1[2]
        
        list_of_candidates[candidate1] = list_of_candidates[candidate1] + 1

for candidate2 in list_of_candidates:
        vote_count = list_of_candidates[candidate2]
        pct = round((vote_count / row_count), 2 ) * 100
        print("{key} : ({value}) => {pct}%".format(key=candidate2, value=vote_count, pct=pct))
print('------------------')  
winner = max(list_of_candidates, key=list_of_candidates.get)   
print('The winner is: ', winner)
print('------------------')  
    
    

