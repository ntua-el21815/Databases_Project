USE cookingcontest;

/* Question 3.1 */
SELECT AVG(score) AS `Average Score`,chefs.name AS 'Cook Name',chefs.surname AS 'Cook Surname' 
	FROM rates 
    JOIN chefs ON chefs.id = rates.contestant_id 
    GROUP BY contestant_id 
    ORDER BY `Average Score` DESC;

SELECT AVG(score) AS `Average Score`,cuisines.country_name AS 'Cuisine' 
	FROM rates 
    JOIN chefs_recipes_episode ON rates.contestant_id = chefs_recipes_episode.chef_id 
    JOIN recipes ON recipes.id = chefs_recipes_episode.recipe_id 
    JOIN cuisines ON cuisines.id = recipes.cuisine_id 
    GROUP BY cuisine_id 
    ORDER BY `Average Score` DESC;
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
SELECT chefs.id 'ID of Chef',chefs.name 'Chef\'s Name' ,chefs.surname 'Chef\'s Surname' 
    FROM chefs 
    WHERE id NOT IN (SELECT DISTINCT(judge_id) FROM is_judge);
/* End of Question 3.4 */

/* Question 3.5 */
/* Selecting all the judges that have been in the same number of episodes and have been
in at least 3 episodes within a specific year */
SELECT year_played AS Year,chefs.id AS 'Judge id',chefs.name 'Judge\'s Name',chefs.surname 'Judge\'s Surname',COUNT(DISTINCT is_judge.episode_id) `Episodes`
    FROM chefs 
    JOIN is_judge ON chefs.id = is_judge.judge_id
    JOIN episodes ON is_judge.episode_id = episodes.id
    GROUP BY chefs.id,episodes.year_played
    HAVING `Episodes` > 3
    ORDER BY Year,`Episodes` DESC;
/* End of Question 3.5 */

/* Question 3.6 */
WITH RecipeTags AS (
    SELECT cre.episode_id AS episode_id, rt.recipe_id AS recipe_id, t.tag_name, rt.tag_id
    FROM recipe_tags rt
    JOIN Tags t ON rt.tag_id = t.id
    JOIN chefs_recipes_episode cre ON rt.recipe_id = cre.recipe_id
), TagPairs AS (
    SELECT rt1.tag_name AS tag1, rt2.tag_name AS tag2, rt1.recipe_id
    FROM RecipeTags rt1
    JOIN RecipeTags rt2 ON rt1.recipe_id = rt2.recipe_id AND rt1.tag_name < rt2.tag_name AND rt1.episode_id = rt2.episode_id
)
SELECT COUNT(*) AS `Times Pair Showed up in Contest`, tag1 AS `Tag 1`, tag2 AS `Tag 2`
    FROM TagPairs
    GROUP BY tag1, tag2
    ORDER BY `Times Pair Showed up in Contest` DESC
    LIMIT 3;
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
SELECT e.episode_number AS 'Episode Number',e.year_played AS 'Year Played', COUNT(kfr.kitchenware_id) AS `Kitchenware Used` 
    FROM Episodes e
    JOIN chefs_recipes_episode cre ON e.id = cre.episode_id
    JOIN kitchenware_for_recipe kfr ON cre.recipe_id = kfr.recipe_id
    GROUP BY e.id
    ORDER BY `Kitchenware Used` DESC
    LIMIT 1;
/*End of question 3.8*/ 

/*Question 3.9*/
SELECT episodes.year_played AS "Year",AVG(dietaryinfo.hydrocarbon_content) AS `Average Hydrocarbons`
	FROM episodes 
    JOIN chefs_recipes_episode ON episodes.id = chefs_recipes_episode.episode_id
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
    SELECT cp1.country_name, cp1.year AS year1, cp1.participation_count AS count1, cp2.year AS year2, cp2.participation_count AS count2
    FROM CuisineParticipation cp1
    JOIN CuisineParticipation cp2 
    ON cp1.country_name = cp2.country_name AND cp2.year = cp1.year + 1
)
SELECT country_name 'Ethnic Cuisine',year1 'Year 1',count1 'Participation in Year 1',year2 'Year 2',count2 'Participation in Year 2'
    FROM ConsecutiveYearParticipation
    WHERE count1 = count2;
/*End of Question 3.10

/*Question 3.11*/
SELECT j.name 'Judge\'s Name', j.surname 'Judge\'s Surname', c.name 'Contestant\'s Name', c.surname 'Contestant\'s Surame', SUM(r.score) `Total Score Given`
    FROM rates r
    JOIN Chefs j ON r.judge_id = j.id
    JOIN Chefs c ON r.contestant_id = c.id
    GROUP BY r.judge_id, r.contestant_id
    ORDER BY `Total Score Given` DESC
    LIMIT 5;
/*End of question 3.11*/

/*Question 3.12*/

WITH episode_overall_difficulty AS (
SELECT episodes.year_played AS Year,episodes.episode_number AS episode_num,SUM(recipes.difficulty_level) AS difficulty
    FROM recipes
    JOIN chefs_recipes_episode ON recipes.id = chefs_recipes_episode.recipe_id
    JOIN episodes ON chefs_recipes_episode.episode_id = episodes.id
    GROUP BY episodes.id,episodes.year_played
),
Max_difficulties AS (
SELECT Year,MAX(difficulty) AS Max_difficulty
	FROM episode_overall_difficulty
	GROUP BY Year
)
SELECT episode_overall_difficulty.Year,MIN(episode_num) `Episode Number`,difficulty 'Highest Overall Difficulty on an Episode This Year'
	FROM episode_overall_difficulty
    JOIN Max_difficulties ON episode_overall_difficulty.difficulty = Max_difficulties.Max_difficulty AND episode_overall_difficulty.Year = Max_difficulties.Year
    GROUP BY episode_overall_difficulty.Year;
#Note that the choice to get the minimum episode number instead of all the episodes that satisfy the criteria is solely because the 
#exercise asks for one episode (Which episode? and not Which Episodes?)
/*End of question 3.12*/

/*Question 3.13*/
SELECT e.episode_number 'Episode Number', e.year_played 'Year'
    FROM Episodes e
    JOIN rates r ON e.id = r.episode_id
    JOIN Chefs c ON r.judge_id = c.id OR r.contestant_id = c.id
    GROUP BY e.id
    ORDER BY SUM(c.prof_certification) ASC
    LIMIT 1;
/*End of question 3.13*/


/*Question 3.14*/
SELECT themes.name AS "Theme",COUNT(*) AS Participation
	FROM themes 
    JOIN recipe_theme ON themes.id = recipe_theme.theme_id 
	JOIN chefs_recipes_episode ON recipe_theme.recipe_id = chefs_recipes_episode.recipe_id
	GROUP BY themes.id
	ORDER BY Participation DESC
	LIMIT 1;
/*End of question 3.14. */

/*Question 3.15*/
SELECT name AS Name,descr AS Description FROM foodgroups 
	WHERE foodgroups.id NOT IN 
    (
        SELECT DISTINCT(ingredients.food_group_id) 
        FROM ingredients 
        JOIN requires ON ingredients.id = requires.ingredient_id
        JOIN chefs_recipes_episode ON requires.recipe_id = chefs_recipes_episode.recipe_id
    );
/* End of question 3.15*/