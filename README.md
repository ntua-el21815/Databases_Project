# Databases_Project Cooking Contest

This is the github repo for 6th semester project in databases.

Please whenever you commit something make clear what you did by naming the commit in a clear way.

Remember that in order for you to see a change that another member has made you
have to pull the repo.

To set up the database:
0) Make sure you are running mysql version >= 8.0.
1) Make sure you have python (version 3.10) installed.
2) Install via pip (pip install mysql-connector-python == 8.0.28) mysqlconnector for python.
3) Give (.\Images) folder priviliges to NETOWRK SERVICE to use Image_Loading.py
Right click on folder Images -> properties -> Security.
(See below)

![Add network service to folder Security menu in Windows.](NETWORKSERVICE.jpg)
4) Set Variable secure-file-priv in my.ini (in %PROGRAMDATA% -> MySqlServer -> MySql<Version> -> my.ini) to "" for the Image_Loading Script to work.
5) Restart mysql Server (Stop Server -> Start Server)
6) Run the DDL_Script.sql in mysql.
7) Run the DML_SCRIPT.sql in mysql.
8) In powershell set $Env:MYSQL_KEY = "your_password" as the root password for mysql connection.
   Example : $Env:MYSQL_KEY = "123456789" (Required for Image Loading Script to work.)
9) Run python .\Image_Loading.py (To load the images to the database.)

Notes:
Recipes.json has dummy data for the recipes.
Chefs_dummy_data.json has dummy data for the chefs.
In Images folder lie all the imaIges used in the database.
Lab_stuff includes some queries from this semester's labs.Will be deleted before deadline.

Thank you.
