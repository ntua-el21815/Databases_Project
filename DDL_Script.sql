
CREATE DATABASE CookingContest;

USE CookingContest;

CREATE TABLE Images (
    id INT PRIMARY KEY AUTO_INCREMENT,
    image BLOB NOT NULL
);

CREATE TABLE Cuisines (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    image_id INT,
    FOREIGN KEY (image_id) REFERENCES Images(id)
);

CREATE TABLE Recipes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    short_desc TEXT NOT NULL,
    recipe_type ENUM("Ζαχαροπλαστική","Μαγειρική"), /* Only two types possible */
    difficulty_level TINYINT NOT NULL,
    /* Consraint for the difficulty level: 
    1 - very easy , 2 - easy, 3 - medium, 4 - hard, 5 - very hard
    */
    CONSTRAINT chk_difficulty_level CHECK (difficulty_level BETWEEN 1 AND 5),
    /*Times need to be positive!*/
    prep_time TIME(0) NOT NULL,
    CONSTRAINT chk_prep_time CHECK (prep_time >= '00:00:00'),
    cook_time TIME(0) NOT NULL,
    CONSTRAINT chk_cook_time CHECK (cook_time >= '00:00:00'),
    cuisine_id INT NOT NULL,
    image_id INT,
    FOREIGN KEY (cuisine_id) REFERENCES Cuisines(id),
    FOREIGN KEY (image_id) REFERENCES Images(id)
);

CREATE TABLE Chefs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    surname VARCHAR(255) NOT NULL,
    phone_number VARCHAR(15),
    birth_date DATE NOT NULL,
    /* You must have been born and not be dead to participate. */
    CONSTRAINT chk_birth_date CHECK (birth_date <= CURDATE() AND birth_date >= '1900-01-01'),
    /* Age should be returned at the time of query based on birth date. */
    work_experience TINYINT NOT NULL,
    prof_certification VARCHAR(255)
);

CREATE TABLE Episodes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    episode_number INT NOT NULL,
    winner_id INT NOT NULL,
    year YEAR NOT NULL,
    image_id INT,
    FOREIGN KEY (winner_id) REFERENCES Chefs(id),
    FOREIGN KEY (image_id) REFERENCES Images(id)
);

CREATE TABLE Themes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    descr TEXT NOT NULL,
    image_id INT,
    FOREIGN KEY (image_id) REFERENCES Images(id)
);

CREATE TABLE FoodGroups (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    descr TEXT NOT NULL,
    image_id INT,
    FOREIGN KEY (image_id) REFERENCES Images(id)
);

CREATE TABLE Ingredients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    food_group_id INT NOT NULL,
    name VARCHAR(45) NOT NULL,
    calories_per_100_units INT NOT NULL,
    image_id INT,
    FOREIGN KEY (image_id) REFERENCES Images(id),
    FOREIGN KEY (food_group_id) REFERENCES FoodGroups(id)
);

CREATE TABLE Kitchenware (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    usage_desc TEXT NOT NULL,
    image_id INT,
    FOREIGN KEY (image_id) REFERENCES Images(id)
);

CREATE TABLE Meals (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    image_id INT,
    FOREIGN KEY (image_id) REFERENCES Images(id)
);

/* Creating a stored procedure to calculate the calories of a recipe */

DELIMITER //

CREATE FUNCTION calculate_calories(recipe_id INT) RETURNS DECIMAL(5, 2)
DETERMINISTIC
BEGIN
    /* The function calculates the total calories of a recipe 
    by summing the calories of each ingredient multiplied 
    by the quantity of the ingredient in the recipe */

    DECLARE total_calories DECIMAL(5, 2);

    SELECT SUM(Ingredients.calories_per_100_units * requires.quantity) INTO total_calories
    FROM requires
    JOIN Ingredients ON requires.ingredient_id = Ingredients.id
    WHERE requires.recipe_id = recipe_id;

    RETURN total_calories;
END //

DELIMITER ;


CREATE TABLE DietaryInfo (
    id INT PRIMARY KEY AUTO_INCREMENT,
    recipe_id INT NOT NULL,
    fat_content DECIMAL(5, 2) NOT NULL,
    protein_content DECIMAL(5, 2) NOT NULL,
    hydrocarbon_content DECIMAL(5, 2) NOT NULL,
    calories DECIMAL(2,5)
    /* Calories are calculated by the stored function calculate_calories */
    GENERATED ALWAYS AS (calculate_calories(recipe_id)) VIRTUAL,
    FOREIGN KEY (recipe_id) REFERENCES Recipes(id)
);

CREATE TABLE Steps (
    id INT PRIMARY KEY AUTO_INCREMENT,
    recipe_id INT,
    step_number TINYINT NOT NULL,
    CHECK (step_number > 0),
    step_desc TEXT NOT NULL,
    image_id INT,
    /* The combination of recipe_id and step_number must be unique
       Obviously one recipe can't have the same step two times. */
    CONSTRAINT chk_step_number UNIQUE (recipe_id, step_number),
    FOREIGN KEY (recipe_id) REFERENCES Recipes(id),
    FOREIGN KEY (image_id) REFERENCES Images(id)
);

CREATE TABLE Quantities (
    id INT PRIMARY KEY AUTO_INCREMENT,
    recipe_id INT NOT NULL,
    quantity DECIMAL(5, 2) NOT NULL,
    CONSTRAINT pos_quantity CHECK (quantity > 0),
    FOREIGN KEY (recipe_id) REFERENCES Recipes(id)
);

CREATE TABLE Tags (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tag_name VARCHAR(45) NOT NULL
);

CREATE TABLE episode_cuisines (
    id INT PRIMARY KEY AUTO_INCREMENT,
    episode_id INT NOT NULL,
    cuisine_id INT NOT NULL,
    FOREIGN KEY (episode_id) REFERENCES Episodes(id),
    FOREIGN KEY (cuisine_id) REFERENCES Cuisines(id)
);

CREATE TABLE recipe_theme (
    id INT PRIMARY KEY AUTO_INCREMENT,
    recipe_id INT NOT NULL,
    theme_id INT NOT NULL,
    FOREIGN KEY (recipe_id) REFERENCES Recipes(id),
    FOREIGN KEY (theme_id) REFERENCES Themes(id)
);

CREATE TABLE recipe_meal (
    id INT PRIMARY KEY AUTO_INCREMENT,
    recipe_id INT NOT NULL,
    meal_id INT NOT NULL,
    FOREIGN KEY (recipe_id) REFERENCES Recipes(id),
    FOREIGN KEY (meal_id) REFERENCES Meals(id)
);

CREATE TABLE recipe_tags (
    id INT PRIMARY KEY AUTO_INCREMENT,
    recipe_id INT NOT NULL,
    tag_id INT NOT NULL,
    FOREIGN KEY (recipe_id) REFERENCES Recipes(id),
    FOREIGN KEY (tag_id) REFERENCES Tags(id)
);

CREATE TABLE episode_recipes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    episode_id INT NOT NULL,
    recipe_id INT NOT NULL,
    FOREIGN KEY (episode_id) REFERENCES Episodes(id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes(id)
);

CREATE TABLE requires (
    id INT PRIMARY KEY AUTO_INCREMENT,
    recipe_id INT NOT NULL,
    ingredient_id INT NOT NULL,
    quantity DECIMAL(5, 2) NOT NULL,
    main_ingredient BOOLEAN NOT NULL,
    ingr_type VARCHAR(45) NOT NULL,
    FOREIGN KEY (recipe_id) REFERENCES Recipes(id),
    FOREIGN KEY (ingredient_id) REFERENCES Ingredients(id)
);

CREATE TABLE kitchenware_for_recipe (
    id INT PRIMARY KEY AUTO_INCREMENT,
    recipe_id INT NOT NULL,
    kitchenware_id INT NOT NULL,
    FOREIGN KEY (recipe_id) REFERENCES Recipes(id),
    FOREIGN KEY (kitchenware_id) REFERENCES Kitchenware(id)
);

CREATE TABLE specialises_in (
    id INT PRIMARY KEY AUTO_INCREMENT,
    chef_id INT NOT NULL,
    cuisine_id INT NOT NULL,
    FOREIGN KEY (chef_id) REFERENCES Chefs(id),
    FOREIGN KEY (cuisine_id) REFERENCES Cuisines(id)
);

CREATE TABLE rates (
    id INT PRIMARY KEY AUTO_INCREMENT,
    episode_id INT NOT NULL,
    judge_id INT NOT NULL,
    contestant_id INT NOT NULL,
    score TINYINT NOT NULL,
    /* Score must be between 1 and 5 */
    CONSTRAINT chk_score CHECK (score BETWEEN 1 AND 5),
    FOREIGN KEY (episode_id) REFERENCES Episodes(id),
    FOREIGN KEY (judge_id) REFERENCES Chefs(id),
    FOREIGN KEY (contestant_id) REFERENCES Chefs(id)
);

CREATE TABLE chefs_recipes_episode (
    id INT PRIMARY KEY AUTO_INCREMENT,
    episode_id INT NOT NULL,
    chef_id INT NOT NULL,
    recipe_id INT NOT NULL,
    /* A chef can't participate in the same episode twice */
    CONSTRAINT chk_chef UNIQUE (chef_id, episode_id),
    /* A chef must not participate in three consecutive episodes */
    CONSTRAINT chk_consecutive_episodes CHECK ( 
        (SELECT COUNT(*) FROM chefs_recipes_episode
        WHERE chef_id = chef_id
        AND (
            episode_id = episode_id - 1
            OR episode_id = episode_id - 2
            OR episode_id = episode_id - 3
        )
        ) < 3
    ),
    FOREIGN KEY (episode_id) REFERENCES Episodes(id),
    FOREIGN KEY (chef_id) REFERENCES Chefs(id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes(id)
);

CREATE TABLE is_judge (
    id INT PRIMARY KEY AUTO_INCREMENT,
    judge_id INT NOT NULL,
    episode_id INT NOT NULL,
    /* A chef can't be a judge in the same episode twice */
    CONSTRAINT chk_judge UNIQUE (judge_id, episode_id),
    /* A chef must not be chosen for three consecutive episodes */
    CONSTRAINT chk_consecutive_episodes CHECK (
        (SELECT COUNT(*) FROM is_judge
        WHERE judge_id = judge_id
        AND (
            episode_id = episode_id - 1
            OR episode_id = episode_id - 2
            OR episode_id = episode_id - 3
        )
        ) < 3
    ),
    FOREIGN KEY (judge_id) REFERENCES Chefs(id),
    FOREIGN KEY (episode_id) REFERENCES Episodes(id)
);