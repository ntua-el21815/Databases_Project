/*This creates a chef user with the privileges to SELECT, INSERT, UPDATE and ALTER ON the recipes and chefs tables*/

CREATE USER 'chef'@'localhost' IDENTIFIED BY 'chef123';/*Change password to your desired password*/
GRANT SELECT, INSERT, UPDATE, ALTER ON cookingcontest.recipes TO 'chef'@'localhost';
GRANT SELECT, INSERT, UPDATE, ALTER ON cookingcontest.chefs TO 'chef'@'localhost';
FLUSH PRIVILEGES;  -- This ensures that the privileges are refreshed and applied.
/*You can use SHOW GRANTS command to see the privileges of the user*/

/*After creating the user, click on the Database tab,select Manage Connections, and then click on the Add Connection button.
Use the credentials of the user you just created.Finally, click on the connect to Database option,also under the Database tab*/

CREATE USER 'admin'@'localhost' IDENTIFIED BY "admin123";/*Change password to your desired password*/

GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;  -- This ensures that the privileges are refreshed and applied.