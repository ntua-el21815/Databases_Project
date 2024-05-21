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
1) Make sure you are running mysql version >= 8.0.
2) Make sure you have python (version >= 3.10) installed.
3) Install via pip (pip install mysql-connector-python==8.0.28) mysqlconnector for python.
4) Run the DDL_Script.sql in mysql.
5) Run the DML_SCRIPT.sql in mysql.
6) In powershell run $Env:MYSQL_KEY = "your_password" as the root password for mysql connection.
   Example : $Env:MYSQL_KEY = "123456789" (Required for Image Loading and Episode Generation Script to work.Make sure you are in the directory the repo is stored in!)
7) Run python .\Image_Loading.py (To load the images to the database.)
8) If yow want to generate additional episodes run python .\One_Episode_Gen.py,to generate one episode at a time. (mysqlconnector mentioned above is a prerequisite).


Notes:
Recipes.json has dummy data for the recipes.
Chefs_dummy_data.json has dummy data for the chefs.
In Images folder lie all the images used in the database.

Thank you.
