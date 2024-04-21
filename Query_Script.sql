USE cookingcontest;

SELECT recipes.name,ingredients.name,requires.quantity FROM recipes JOIN requires JOIN ingredients WHERE recipes.id = requires.recipe_id AND ingredients.id = requires.ingredient_id;