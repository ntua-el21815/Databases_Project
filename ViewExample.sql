CREATE VIEW name_surname AS
SELECT* FROM  chefs JOIN chefs_recipes_episode ON chefs.id = chefs_recipes_episode.chef_id
JOIN recipes ON chefs_recipes_episode.chef_id = recipes.id
WHERE chefs.name = 'name' AND chefs.surname = 'surname';

