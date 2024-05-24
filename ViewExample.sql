CREATE VIEW name_surname AS/*We would replace name and surname with those gathered from the sign-up form*/
SELECT* FROM  chefs JOIN chefs_recipes_episode ON chefs.id = chefs_recipes_episode.chef_id
 JOIN recipes ON chefs_recipes_episode.chef_id = recipes.id
 JOIN requires ON recipes.id = requires.recipe_id
 JOIN steps ON recipes.id = steps.recipe_id
 JOIN ingredients ON requires.ingredient_id = ingredients.id
 JOIN kitchenware_for_recipe ON recipes.id = kitchenware_for_recipe.recipe_id
 JOIN kitchenware ON kitchenware_for_recipe.kitchenware_id = kitchenware.id
WHERE chefs.name = 'name' AND chefs.surname = 'surname';