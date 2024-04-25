USE cookingcontest;

/*
SELECT recipes.id,recipes.name,themes.name,themes.descr FROM recipes JOIN recipe_theme JOIN themes WHERE recipes.id = recipe_theme.recipe_id AND recipe_theme.theme_id = themes.id;

SELECT ingredients.name,foodgroups.name FROM ingredients JOIN foodgroups WHERE ingredients.food_group_id= foodgroups.id;

SELECT chefs.name,chefs.surname,cuisines.country_name FROM chefs JOIN specialises_in JOIN cuisines WHERE chefs.id = specialises_in.chef_id AND specialises_in.cuisine_id = cuisines.id;

SELECT *,get_title(prof_certification) certfiication FROM chefs;
*/

SELECT AVG(score) AS Average,chefs.name AS 'Cook Name',chefs.surname AS 'Cook Surname' FROM rates JOIN chefs WHERE chefs.id = rates.contestant_id GROUP BY contestant_id ORDER BY Average DESC;
