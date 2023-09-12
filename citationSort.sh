#!/bin/bash
# Run with bash citationSort.sh
# regex101.com helped
# .*\r\n Title
# .*\r\n 1st Line of description
# .*\r\n 2nd Line of description
# Save\r\n
# Cite Cited by [0-9]+ Related articles.*\r\n
# This needs to occur to enable the 5-line pattern below,
#  some of the Google Scholar page markers were broken and put the Save button within the Cited by element, not proper
sed -E "s/Save /Save\r\n/g" htmlContentAndAppensions.txt > 0.txt
pcregrep --buffer-size 2000000 -M ".*\r\n.*\r\n.*\r\nSave\r\nCite Cited by [0-9]+ Related articles.*\r\n" 0.txt > 1.txt
# BETA pcregrep --buffer-size 2000000 -M ".*\r\n.*\r\n.*?\r?\n?.*?\r?\n?.*?\r?\n?.*?\r?\n?Save\r\nCite Cited by [0-9]+ Related articles.*\r\n" 0.txt > 1.txt
# Put all rows on one line, to begin separation into columns for the spreadsheet with @ as the delimiter
cat 1.txt | tr '\r\n' '@' > 2.txt
# Making the CSV file with the @ delimiter, for use once we find the columns to be stored
# touch htmlContentAndAppensions.csv
echo "Title@DescriptionLine1@DescriptionLine2@CitedBy" > 3.csv
# Finding factors and numbers below while removing fluff, such as all Saves occurrences and version amounts
# Template Regex test below with subexpressions for rearrangement/removal
## egrep "([^@]*)@{2}([^@]*)@{2}([^@]*)@{2}Save@@Cite Cited by ([0-9]+) Related articles[^@]*@{2}" 1.txt
# Begin removal of saves and trimming of the trailing double @
sed -E "s/([^@]*)@{2}([^@]*)@{2}([^@]*)@{2}Save@@Cite Cited by ([0-9]+) Related articles[^@]*@{2}/\1@\2@\3@\4\n/g" 2.txt >> 3.csv
# Open the CSV file with Libreoffice and set the delimiter to @
# Then you may sort by the number of cited by column after adding filters
