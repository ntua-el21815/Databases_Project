/*This creates a chef user with the privileges to SELECT, INSERT, UPDATE ON all the tables that concern their data and their recipes.*/

DROP USER IF EXISTS 'chef'@'localhost';/*This is to ensure that the user is not already created*/
DROP USER IF EXISTS 'admin'@'localhost';/*This is to ensure that the user is not already created*/

CREATE USER 'chef'@'localhost' IDENTIFIED BY 'chef123';/*Change password to your desired password*/
GRANT SELECT, INSERT, UPDATE ON cookingcontest.recipes TO 'chef'@'localhost';
GRANT SELECT, INSERT, UPDATE ON cookingcontest.requires TO 'chef'@'localhost';
GRANT SELECT, INSERT, UPDATE ON cookingcontest.steps TO 'chef'@'localhost';
GRANT SELECT, INSERT, UPDATE ON cookingcontest.ingredients TO 'chef'@'localhost';
GRANT SELECT, INSERT, UPDATE ON cookingcontest.kitchenware TO 'chef'@'localhost';
GRANT SELECT, INSERT, UPDATE ON cookingcontest.kitchenware_for_recipe TO 'chef'@'localhost';
GRANT SELECT, INSERT, UPDATE ON cookingcontest.chefs TO 'chef'@'localhost';
FLUSH PRIVILEGES;  -- This ensures that the privileges are refreshed and applied.
/*You can use SHOW GRANTS command to see the privileges of the user*/

/*After creating the user, click on the Database tab,select Manage Connections, and then click on the Add Connection button.
Use the credentials of the user you just created.Finally, click on the connect to Database option,also under the Database tab*/

CREATE USER 'admin'@'localhost' IDENTIFIED BY "admin123";/*Change password to your desired password*/

GRANT INSERT, UPDATE, SELECT ON cookingcontest.* TO 'admin'@'localhost';
GRANT SUPER ON *.* TO 'admin'@'localhost';
FLUSH PRIVILEGES;  -- This ensures that the privileges are refreshed and applied.