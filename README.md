# FSI_Assignment
SQL to Json format downloading Json File, Creating Procedure, Creating Scheduler

---Used Swoflake and SnowSQL---

Created Database, Schema and Table 
For staging the data run the command in snowSQL--> put file://file_Path @~Staging_Area auto_compression = false/true;
Created the Role and User and granted the Permission

Created the Procedure for finding out the AvgIncome of perticular Occupation and Avg car Value for the perticular Car and those values added into new created file
Those files added into the JSON file

To creating JSON file

Created the Table of values with data type Variant
Created the file format JSON 
Created the staging for loading the Data
Loaded the staging data into JSON file

Created the schedular
Have to mention the compute engine + Time and Calling the Procedure

Createad the Matterialised view 

Time travel functionality
AT|BEFORE

AT -- Indicates that at perfticular time int the name only this get Indicates
AT(Statement => .....)
AT(Timestamp => .....)
AT(Offset => .....)


Before -- This indicates that Before ome operation we can travel back to the time
Before(Statement => 'Query ID')







