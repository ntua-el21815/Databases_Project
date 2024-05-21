# Databases_Project Cooking Contest

This is the github repo for 6th semester project in databases.
The main goal is the development of a functional Database for a
hypothetical Cooking Contest.

Please whenever you commit something make clear what you did by naming the commit in a clear way.

Remember that in order for you to see a change that another member has made you
have to pull the repo.

To download our project (Three Options): <br>
1) Download a .zip archive from https://github.com/NicholasAgg/Databases_Project/ (Recommended since changes are disallowed anyways) and extract it into your desired directory.
2) Download Github Desktop login with your credentials and clone the repo into your desired Folder.
3) Install Github CLI as described here (https://github.com/cli/cli#installation), then login with your credntials (Command: gh auth login),and then run gh repo clone NicholasAgg/Databases_Project, to clone the repo into your desired directory.

To set up the database: <br>
0) Make sure you are running mysql version >= 8.0.
1) Make sure you have python (version 3.10) installed.
2) Install via pip (pip install mysql-connector-python==8.0.28) mysqlconnector for python.
3) Give (.\Images) folder priviliges to NETOWRK SERVICE to use Image_Loading.py
Right click on folder Images -> properties -> Security.
Note : The NETWORK SERVICE username might be different on your machine.To check its exact name you
have to locate MYSQL 80 Service (In Windows Task Manager),right click it,then go to details,there you will find its username which is needed.
(See below) <br>
![Add network service to folder Security menu in Windows.](NETWORKSERVICE.jpg)
4) Set Variable secure-file-priv in my.ini (in %PROGRAMDATA% -> MySqlServer -> MySql<Version> -> my.ini) to "" for the Image_Loading Script to work.We recommend instead of "" to set it to the directory in which the application is stored.
5) Restart mysql Server (Stop Server -> Start Server)
6) Run the DDL_Script.sql in mysql.
7) Run the DML_SCRIPT.sql in mysql.
8) Run ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Your Password'.
9) In powershell set $Env:MYSQL_KEY = "your_password" as the root password for mysql connection.
   Example : $Env:MYSQL_KEY = "123456789" (Required for Image Loading and Episode Generation Script to work.)
11) Run python .\Image_Loading.py (To load the images to the database.)
12) If yow want to generate additional episodes run python .\One_Episode_Gen.py,to generate one episode at a time. (mysqlconnector mentioned above is a prerequisite).


Notes:
Recipes.json has dummy data for the recipes.
Chefs_dummy_data.json has dummy data for the chefs.
In Images folder lie all the imaIges used in the database.

Thank you.
