/* Random Queries to validate stuff */
SELECT * FROM images;

SELECT * FROM is_judge;

SELECT * FROM dietaryinfo;

SELECT * FROM themes;

SELECT * FROM cuisines;

SELECT  * FROM chefs;

SELECT * FROM episodes;

SELECT recipes.id,recipes.name AS 'Recipe Name',ingredients.name AS 'Main Ingredient' FROM recipes JOIN requires JOIN ingredients
	WHERE recipes.id = requires.recipe_id AND requires.ingredient_id = ingredients.id AND requires.main_ingredient = 1;
    
SELECT recipes.id,recipes.name,themes.name,themes.descr FROM recipes JOIN recipe_theme JOIN themes WHERE recipes.id = recipe_theme.recipe_id AND recipe_theme.theme_id = themes.id;

SELECT ingredients.name,foodgroups.name FROM ingredients JOIN foodgroups WHERE ingredients.food_group_id= foodgroups.id;

SELECT chefs.name,chefs.surname,cuisines.country_name FROM chefs JOIN specialises_in JOIN cuisines WHERE chefs.id = specialises_in.chef_id AND specialises_in.cuisine_id = cuisines.id;

SELECT *,get_title(prof_certification) certfiication FROM chefs;

SELECT episode_number,year_played,chefs.name,chefs.surname FROM chefs JOIN episodes WHERE chefs.id = episodes.winner_id;

SELECT age(birth_date) AS 'Age' FROM chefs;

SELECT recipes.name,images.image FROM recipes JOIN images WHERE recipes.image_id = images.id OR recipes.image_id IS NULL;

SELECT chefs.name,images.image FROM chefs JOIN images WHERE chefs.image_id = images.id OR chefs.image_id IS NULL;

SELECT themes.name,images.image FROM themes JOIN images WHERE themes.image_id = images.id OR themes.image_id IS NULL;

SELECT foodgroups.name,images.image FROM foodgroups JOIN images WHERE foodgroups.image_id = images.id OR foodgroups.image_id IS NULL;

SELECT episodes.year_played,episodes.episode_number,images.image FROM episodes JOIN images WHERE episodes.image_id = images.id OR episodes.image_id = NULL;

SELECT ingredients.name,images.image FROM ingredients JOIN images WHERE ingredients.image_id = images.id OR ingredients.image_id IS NULL;

SELECT * FROM episodes;

SET SQL_SAFE_UPDATES = 0;

SHOW VARIABLES LIKE 'secure_file_priv';

GRANT FILE ON *.* TO 'root'@'localhost';

DELETE FROM Images;
UPDATE Recipes SET image_id = NULL;

SELECT * FROM chefs_recipes_episode;

SELECT episodes.year_played,episodes.episode_number,cuisines.country_name 
	FROM episode_cuisines JOIN episodes JOIN cuisines 
	WHERE episode_cuisines.episode_id = episodes.id AND episode_cuisines.cuisine_id = cuisines.id
    ORDER BY year_played,episode_number ASC;

/* 3.14 Validation */

select * from themes;
SELECT * FROM recipe_theme;
SELECT COUNT(*) FROM chefs_recipes_episode;

/* End of Random Queries */