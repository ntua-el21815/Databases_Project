USE cookingcontest;

/* Random Queries to validate stuff */
SELECT * FROM images;

SELECT * FROM is_judge;

SELECT * FROM dietaryinfo;

SELECT * FROM themes;

SELECT * FROM cuisines;

SELECT  * FROM chefs;

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

SELECT episodes.year_played,episodes.episode_number,images.image FROM episodes JOIN images WHERE episodes.image_id = images.id;

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

/* Question 3.1 */
SELECT AVG(score) AS Average,chefs.name AS 'Cook Name',chefs.surname AS 'Cook Surname' 
	FROM rates 
    JOIN chefs ON chefs.id = rates.contestant_id 
    GROUP BY contestant_id 
    ORDER BY Average DESC;

SELECT AVG(score) AS Average,cuisines.country_name AS 'Cuisine' 
	FROM rates 
    JOIN chefs_recipes_episode ON rates.contestant_id = chefs_recipes_episode.chef_id 
    JOIN recipes ON recipes.id = chefs_recipes_episode.recipe_id 
    JOIN cuisines ON cuisines.id = recipes.cuisine_id 
    GROUP BY cuisine_id 
    ORDER BY Average DESC;
/* End of Question 3.1 */

/* Question 3.2 */
SELECT episodes.year_played AS Year,cuisines.country_name AS Cuisine,chefs.name AS "Name",chefs.surname AS "Surname"
	FROM episodes 
    JOIN chefs_recipes_episode ON episodes.id = chefs_recipes_episode.episode_id 
    JOIN recipes ON recipes.id = chefs_recipes_episode.recipe_id
    JOIN cuisines ON cuisines.id = recipes.cuisine_id
    JOIN specialises_in ON recipes.cuisine_id = specialises_in.cuisine_id
    JOIN chefs ON chefs.id = specialises_in.chef_id 
	GROUP BY year_played,cuisines.id,chefs.id 
    ORDER BY year_played;

SELECT episodes.year_played AS Year,cuisines.country_name AS Cuisine,chefs.name AS "Name",chefs.surname AS "Surname"
	FROM episodes 
    JOIN chefs_recipes_episode ON episodes.id = chefs_recipes_episode.episode_id
    JOIN chefs ON chefs_recipes_episode.chef_id = chefs.id 
    JOIN recipes ON recipes.id = chefs_recipes_episode.recipe_id
    JOIN cuisines ON cuisines.id = recipes.cuisine_id
    GROUP BY year_played,cuisines.id,chefs.id 
    ORDER BY year_played;
/* End of Question 3.2 */

/* Question 3.3 */
SELECT chefs.name AS 'Chef Name', chefs.surname AS 'Chef Surname', age(chefs.birth_date) AS Age,
    (
        SELECT COUNT(*) FROM chef_recipes WHERE chef_recipes.chef_id = chefs.id
    ) AS Recipes
	FROM chefs 
    HAVING Age < 30 
    ORDER BY Recipes DESC;
/* End of Question 3.3 */

/* Question 3.4 */
SELECT * FROM chefs WHERE id NOT IN (SELECT DISTINCT(judge_id) FROM is_judge);
/* End of Question 3.4 */

/* Question 3.5 */
/* Selecting all the judges that have been in the same number of episodes and have been
in at least 3 episodes within a specific year */
SELECT year_played AS Year,chefs.id AS 'Chef id',chefs.name,chefs.surname,COUNT(DISTINCT chefs_recipes_episode.episode_id) 'Episodes' 
    FROM chefs 
    JOIN chefs_recipes_episode ON chefs.id = chefs_recipes_episode.chef_id 
    JOIN is_judge ON chefs.id = is_judge.judge_id
    JOIN episodes ON chefs_recipes_episode.episode_id = episodes.id
    GROUP BY Year,chefs.id
    HAVING COUNT(DISTINCT chefs_recipes_episode.episode_id) > 3
    ORDER BY Year,Episodes DESC;
/*This query broke because of the constraint of 3 consecutive episodes.WHAT SHOULD WE DO? */
/*Fixed it by adding some persistent chefs in the Script of random episode Generation.*/
/* End of Question 3.5 */

/* Question 3.6 */
WITH RecipeTags AS (
    SELECT r.id AS recipe_id, t.tag_name
    FROM Recipes r
    JOIN recipe_tags rt ON r.id = rt.recipe_id
    JOIN Tags t ON rt.tag_id = t.id
    JOIN chefs_recipes_episode cre ON r.id = cre.recipe_id
), TagPairs AS (
    SELECT rt1.recipe_id, rt1.tag_name AS tag1, rt2.tag_name AS tag2
    FROM RecipeTags rt1
    JOIN RecipeTags rt2 ON rt1.recipe_id = rt2.recipe_id AND rt1.tag_name < rt2.tag_name
)

select count(recipe_id) as counter,tag1,tag2 from TagPairs
group by tag1,tag2
order by counter desc
limit 3;
/* End of Question 3.6*/

/*Question 3.7*/
SELECT DISTINCT chefs.id AS "Chef ID",chefs.name AS "Chef's Name",chefs.surname AS "Chef's Surname",(SELECT COUNT(*) FROM chefs_recipes_episode WHERE chefs_recipes_episode.chef_id = chefs.id) AS Participation
	FROM chefs JOIN chefs_recipes_episode ON chefs.id = chefs_recipes_episode.chef_id
	HAVING Participation <= (SELECT MAX(Participation) - 5 FROM (
        SELECT 
            COUNT(chef_id) AS Participation
        FROM 
            chefs_recipes_episode
        GROUP BY 
            chef_id
    ) AS Subquery)
	ORDER BY Participation DESC;
/*End of question 3.7*/

/*Question 3.8*/
SELECT e.episode_number, COUNT(kfr.kitchenware_id) AS equipment_count
FROM Episodes e
JOIN chefs_recipes_episode cre ON e.id = cre.episode_id
JOIN kitchenware_for_recipe kfr ON cre.recipe_id = kfr.recipe_id
GROUP BY e.id
ORDER BY equipment_count DESC
LIMIT 1;
/*End of question 3.8*/ 



/*Question 3.9*/
SELECT episodes.year_played AS "Year",AVG(dietaryinfo.hydrocarbon_content) AS AvgHydrocarbon
	FROM episodes JOIN chefs_recipes_episode ON episodes.id = chefs_recipes_episode.episode_id
	JOIN dietaryinfo ON chefs_recipes_episode.recipe_id = dietaryinfo.recipe_id
	GROUP BY episodes.year_played;
/*End of question 3.9*/

/*Question 3.10*/
WITH CuisineParticipation AS (
    SELECT 
        c.country_name,
        e.year_played AS year,
        COUNT(*) AS participation_count
    FROM episodes e
    JOIN chefs_recipes_episode cre ON e.id = cre.episode_id
    JOIN Recipes r ON cre.recipe_id = r.id
    JOIN Cuisines c ON r.cuisine_id = c.id
    GROUP BY c.country_name, year_played
    HAVING COUNT(*) >= 3
),
ConsecutiveYearParticipation AS (
    SELECT 
        cp1.country_name,
        cp1.year AS year1,
        cp1.participation_count AS count1,
        cp2.year AS year2,
        cp2.participation_count AS count2
    FROM CuisineParticipation cp1
    JOIN CuisineParticipation cp2 
        ON cp1.country_name = cp2.country_name 
        AND cp2.year = cp1.year + 1
)
SELECT 
    country_name,
    year1,
    count1,
    year2,
    count2
FROM ConsecutiveYearParticipation
WHERE count1 = count2;
/*End of Question 3.10

/*Question 3.11*/
SELECT 
    j.name AS judge_name, 
    j.surname AS judge_surname, 
    c.name AS contestant_name, 
    c.surname AS contestant_surname, 
    SUM(r.score) AS total_score
FROM 
    rates r
JOIN 
    Chefs j ON r.judge_id = j.id
JOIN 
    Chefs c ON r.contestant_id = c.id
GROUP BY 
    r.judge_id, r.contestant_id
ORDER BY 
    total_score DESC
LIMIT 5;
/*End of question 3.11*/

/*Question 3.12*/
with difficulty as (
select recipes.name as name,recipes.difficulty_level as difficul,chefs_recipes_episode.episode_id as episode,episodes.year_played as year from recipes
join chefs_recipes_episode on recipes.id=chefs_recipes_episode.recipe_id
join episodes on chefs_recipes_episode.episode_id=episodes.episode_number
)
, difficulty_of_episode as (
select  avg(difficul) as difficul,episode,year from difficulty
group by episode,year
)
/*End of question 3.12*/

/*Question 3.13*/
SELECT e.id, e.episode_number, AVG(c.prof_certification) as avg_certification
FROM Episodes e
JOIN rates r ON e.id = r.episode_id
JOIN Chefs c ON r.judge_id = c.id OR r.contestant_id = c.id
GROUP BY e.id, e.episode_number
ORDER BY avg_certification ASC
LIMIT 1;
/*End of question 3.13*/


/*Question 3.14*/
SELECT themes.name AS "Theme",COUNT(*) AS Participation
	FROM themes JOIN recipe_theme ON themes.id = recipe_theme.theme_id 
	JOIN chefs_recipes_episode ON recipe_theme.recipe_id = chefs_recipes_episode.recipe_id
	GROUP BY themes.name
	ORDER BY Participation DESC
	LIMIT 1;
/*End of question 3.14. */

/*Question 3.15*/
SELECT name AS Name,descr AS Description FROM foodgroups 
	WHERE foodgroups.id NOT IN (SELECT DISTINCT(ingredients.food_group_id) 
    FROM ingredients 
    JOIN requires ON ingredients.id = requires.ingredient_id
	JOIN chefs_recipes_episode ON requires.recipe_id = chefs_recipes_episode.recipe_id);
/* End of question 3.15*/