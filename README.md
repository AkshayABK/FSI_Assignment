# FSI_Assignment
SQL to Json format downloading Json File, Creating Procedure, Creating Scheduler

## Skills 
1. Swoflake
2. SnowSQL

## Assignment Number

:one:

Created Database, Schema and Table 
For staging the data run the command in snowSQL 
  - put file://file_Path @~Staging_Area auto_compression = false/true;

:two: 

Created the Role and User and granted the Permission

:three:

Created the Procedure for finding out the AvgIncome of perticular Occupation and Avg car Value for the perticular Car and those values added into new created file
Those files added into the JSON file

:four:

To creating JSON file
  - Created the Table of values with data type Variant
  - Created the file format JSON 
  - Created the staging for loading the Data
  - Loaded the staging data into JSON file

:five:

Created the schedular
> [!IMPORTANT]
Have to mention the compute engine + Time and Calling the Procedure

:six:

Createad the Matterialised view 

:seven:

Time travel functionality

AT|BEFORE

1. AT 
  - Indicates that at perfticular time int the name only this get Indicates

> [!IMPORTANT]
AT(Statement => .....)
AT(Timestamp => .....)
AT(Offset => .....)


2. Before 
   - This indicates that Before ome operation we can travel back to the time
  
> [!IMPORTANT]
Before(Statement => 'Query ID')







