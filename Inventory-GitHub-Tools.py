#!/usr/bin/python3

import csv
import pathlib
import re
import time

searchPath = "<insert path here>"

#rawFolders is a temp storage list
rawFolders = []
#modFolders takes the raw and modifies it for accuracy
modFolders = []
#gitFolders is really the github tool names
gitFolders = []
#gitFolderLocations is the full path to each tool on disk
gitFolderLocations = []
#gitURLs is the download link to each tool
gitURLs = []

# Filtering files from folders && storing folder names in list
basepath = pathlib.Path(searchPath)
basepathContents = basepath.iterdir()
for item in basepathContents:
    if item.is_file():
        # print("\tFile:\t" + item.name)
        pass
    else:
        # print("Folder:\t" + item.name)
        ## for some reason people are keeping old tools with the hidden folder designation...
        rawFolders.append(item.name)

# Eliminating leading '.' from folder names
for item in rawFolders:
    matchObj = re.match(r'^[.]', item)
    if matchObj:
        # print("Match Found:\t" + item)
        pass
    else:
        # print("\tRegular Folder:\t" + item)
        modFolders.append(item)

# Finding only folders with ".git" subfolder
for item in modFolders:
    searchString = searchPath + item + "/.git"
    basepath = pathlib.Path(searchPath + item + "/.git")
    basepathContents = basepath.exists()
    if basepathContents == True:
        gitFolders.append(item)
        gitFolderLocations.append(searchString)
        # print("File:\t" + item + "\tis a GitHub tool")
    else:
        pass

# Obtaining URLS from Git folders
for item in gitFolderLocations:
    searchFile = item + "/config"
    tempList = []
    with open (searchFile, 'rt') as myfile:
        for line in myfile:
            tempList.append(line)
    gitURLs.append(tempList[6].strip().split( )[2])

# Printing finalized results to the screen
# count = 0
# print("No.,Tool Name, Tool Location, GitHub URL to Download")
# while count < len(gitURLs):
#     print(str(count) + "," + gitFolders[count] + "," + gitFolderLocations[count] + "," + gitURLs[count])
#     count += 1

# Writing finalized results to CSV file
filename = "Github-Tools-" + time.strftime('%Y%m%d' + ".csv")
count = 0
with open(filename, 'w', newline='') as csvfile:
    fieldnames = ['No.', 'Tool Name', 'Tool Location', 'GitHub URL to Download']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()
    while count < len(gitURLs):
        writer.writerow({'No.': str(count), 'Tool Name': gitFolders[count], 'Tool Location': gitFolderLocations[count], 'GitHub URL to Download': gitURLs[count]})
        count += 1

# Comparing list lengths to verify actions are being taken
# print("Length of rawFolders:\t" + str(len(rawFolders)))
# print("Length of modFolders:\t" + str(len(modFolders)))
# print("Length of gitFolders:\t" + str(len(gitFolders)))
# print("Length of gitFolderLocations:\t" + str(len(gitFolderLocations)))
# print("Length of gitURLs:\t" + str(len(gitURLs)))
