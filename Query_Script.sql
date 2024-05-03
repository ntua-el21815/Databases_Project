USE cookingcontest;

/* Random Queries to validate stuff */
SELECT * FROM images;

SELECT * FROM dietaryinfo;

SELECT * FROM recipes;

SELECT recipes.id,recipes.name AS 'Recipe Name',ingredients.name AS 'Main Ingredient' FROM recipes JOIN requires JOIN ingredients
	WHERE recipes.id = requires.recipe_id AND requires.ingredient_id = ingredients.id AND requires.main_ingredient = 1;
    
SELECT recipes.id,recipes.name,themes.name,themes.descr FROM recipes JOIN recipe_theme JOIN themes WHERE recipes.id = recipe_theme.recipe_id AND recipe_theme.theme_id = themes.id;

SELECT ingredients.name,foodgroups.name FROM ingredients JOIN foodgroups WHERE ingredients.food_group_id= foodgroups.id;

SELECT chefs.name,chefs.surname,cuisines.country_name FROM chefs JOIN specialises_in JOIN cuisines WHERE chefs.id = specialises_in.chef_id AND specialises_in.cuisine_id = cuisines.id;

SELECT *,get_title(prof_certification) certfiication FROM chefs;

SELECT episode_number,year_played,chefs.name,chefs.surname FROM chefs JOIN episodes WHERE chefs.id = episodes.winner_id;

SELECT age(birth_date) AS 'Age' FROM chefs;

SELECT recipes.name,images.image FROM recipes JOIN images WHERE recipes.image_id = images.id OR recipes.image_id IS NULL;
SELECT * FROM images;

SET SQL_SAFE_UPDATES = 0;

SHOW VARIABLES LIKE 'secure_file_priv';

GRANT FILE ON *.* TO 'root'@'localhost';

SELECT LOAD_FILE('c:\\Users\\nicho\\Documents\\Github_Repos_NicholasAgg\\Databases_Project\\Images\\Recipe_1.jpg');

DELETE FROM Images;

SELECT * FROM chefs_recipes_episode;

SELECT episodes.year_played,episodes.episode_number,cuisines.country_name 
	FROM episode_cuisines JOIN episodes JOIN cuisines 
	WHERE episode_cuisines.episode_id = episodes.id AND episode_cuisines.cuisine_id = cuisines.id
    ORDER BY year_played,episode_number ASC;
/* End of Random Queries */

/* Question 3.1 */
SELECT AVG(score) AS Average,chefs.name AS 'Cook Name',chefs.surname AS 'Cook Surname' FROM rates JOIN chefs WHERE chefs.id = rates.contestant_id GROUP BY contestant_id ORDER BY Average DESC;

SELECT AVG(score) AS Average,cuisines.country_name AS 'Cuisine' FROM rates JOIN chefs_recipes_episode JOIN recipes JOIN cuisines WHERE recipes.id = chefs_recipes_episode.recipe_id AND rates.contestant_id = chefs_recipes_episode.chef_id AND cuisines.id = recipes.cuisine_id GROUP BY cuisine_id ORDER BY Average DESC;
/* End of Question 3.1 */

/* Question 3.2 */
SELECT episodes.year_played,cuisines.country_name,chefs.name,chefs.surname 
	FROM episodes JOIN chefs_recipes_episode JOIN chefs JOIN recipes JOIN cuisines JOIN specialises_in 
	WHERE episodes.id = chefs_recipes_episode.episode_id AND cuisines.id = recipes.cuisine_id AND recipes.id = chefs_recipes_episode.recipe_id AND recipes.cuisine_id = specialises_in.cuisine_id AND chefs.id = specialises_in.chef_id 
	GROUP BY year_played,cuisines.id,chefs.id 
    ORDER BY year_played;
SELECT episodes.year_played,cuisines.country_name,chefs.name,chefs.surname 
	FROM episodes JOIN chefs_recipes_episode JOIN chefs JOIN recipes JOIN cuisines 
    WHERE episodes.id = chefs_recipes_episode.episode_id AND cuisines.id = recipes.cuisine_id AND recipes.id = chefs_recipes_episode.recipe_id AND chefs_recipes_episode.chef_id = chefs.id 
    GROUP BY year_played,cuisines.id,chefs.id 
    ORDER BY year_played;
/* End of Question 3.2 */

/* Question 3.3 */
SELECT chefs.name AS 'Chef Name', chefs.surname AS 'Chef Surname', age(chefs.birth_date) AS Age,
    (
        SELECT COUNT(*) FROM chef_recipes WHERE chef_recipes.chef_id = chefs.id
    ) AS Recipes
FROM chefs WHERE age(birth_date) < 30 ORDER BY Recipes DESC;
/* End of Question 3.3 */

/* Question 3.4 */
SELECT * FROM chefs WHERE id NOT IN (SELECT DISTINCT(judge_id) FROM is_judge);
/* End of Question 3.4 */

/* Question 3.5 */
/* Selecting all the judges that have been in the same number of episodes and have been
in at least 3 episodes within a specific year */
SELECT year_played AS Year,chefs.id AS 'Chef id',chefs.name,chefs.surname,COUNT(DISTINCT chefs_recipes_episode.episode_id) 'Episodes' 
    FROM chefs JOIN chefs_recipes_episode JOIN is_judge JOIN episodes
    WHERE chefs.id = chefs_recipes_episode.chef_id AND chefs.id = is_judge.judge_id AND chefs_recipes_episode.episode_id = episodes.id
    GROUP BY year_played,chefs.id
    HAVING COUNT(DISTINCT chefs_recipes_episode.episode_id) > 3
    ORDER BY Year,Episodes DESC;
/* End of Question 3.5 */