SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS CookingContest;

CREATE SCHEMA CookingContest;

USE CookingContest;

CREATE TABLE Images (
    id INT PRIMARY KEY AUTO_INCREMENT,
    image LONGBLOB NOT NULL,
    descr TEXT
);

CREATE TABLE Cuisines (
    id INT PRIMARY KEY AUTO_INCREMENT,
    country_name VARCHAR(45) NOT NULL,
    image_id INT,
    FOREIGN KEY (image_id) REFERENCES Images(id)
);

CREATE TABLE Recipes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    short_desc TEXT,
    recipe_type ENUM("pastry","gastronomy"), /* Only two types possible */
    difficulty_level TINYINT NOT NULL,
    /* Every recipe can have up to 3 tips.*/
    TIP1 TINYTEXT,
    TIP2 TINYTEXT,
    TIP3 TINYTEXT,
    /* Consraint for the difficulty level: 
    1 - very easy , 2 - easy, 3 - medium, 4 - hard, 5 - very hard
    */
    CONSTRAINT chk_difficulty_level CHECK (difficulty_level BETWEEN 1 AND 5),
    /*Times need to be positive!*/
    prep_time TIME(0) NOT NULL,
    CONSTRAINT chk_prep_time CHECK (prep_time >= '00:00:00'),
    cook_time TIME(0) NOT NULL,
    CONSTRAINT chk_cook_time CHECK (cook_time >= '00:00:00'),
    total_time TIME(0) AS (ADDTIME(prep_time, cook_time)) NOT NULL,
    cuisine_id INT NOT NULL,
    image_id INT,
    FOREIGN KEY (cuisine_id) REFERENCES Cuisines(id),
    FOREIGN KEY (image_id) REFERENCES Images(id)
);

CREATE TABLE Chefs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    surname VARCHAR(255) NOT NULL,
    /* VARCHAR was chosen to accomodate foriegn numbers 0049 ...*/
    phone_number VARCHAR(15),
    CONSTRAINT chk_phone_number CHECK (phone_number REGEXP '^[0-9]{0,15}$'),
    birth_date DATE NOT NULL,
    /* You must have been born and not be dead to participate. */
    /* CONSTRAINT chk_birth_date CHECK (birth_date <= CURDATE() AND birth_date >= '1900-01-01'), Make this as trigger. */
    /* Age should be returned at the time of query based on birth date. */
    work_experience TINYINT,
    prof_certification TINYINT NOT NULL,
    image_id INT,
    FOREIGN KEY (image_id) REFERENCES Images(id),
    CONSTRAINT chk_work_experience CHECK (work_experience >= 0),
    CONSTRAINT chk_prof_certification CHECK (prof_certification BETWEEN 0 AND 5 AND NOT NULL)
);

/* Function that takes the number of prof_certification and returns the corresponding title */
DELIMITER //

CREATE FUNCTION get_title(prof_certification INT) RETURNS VARCHAR(45)
DETERMINISTIC
BEGIN
    DECLARE title VARCHAR(45);

    CASE prof_certification
        WHEN 0 THEN SET title = 'None';
        WHEN 1 THEN SET title = 'C Cook';
        WHEN 2 THEN SET title = 'B Cook';
        WHEN 3 THEN SET title = 'A Cook';
        WHEN 4 THEN SET title = 'Sous Chef';
        WHEN 5 THEN SET title = 'Chef';
    END CASE;

    RETURN title;
END //

DELIMITER ;

DELIMITER //

CREATE FUNCTION age(birth_date DATE) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE age INT;
    
    SET age = YEAR(CURDATE()) - YEAR(birth_date);
    RETURN age;
END //

DELIMITER ;

CREATE TABLE Episodes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    episode_number INT NOT NULL,
    CONSTRAINT chk_episode_number CHECK (episode_number > 0),
    /*The winner should be dynamically calculated based on the ratings and other criteria.
      Remember to implement the logic in the application.
    */
    winner_id INT,
    year_played YEAR NOT NULL,
    image_id INT,
    CONSTRAINT CHECK (year_played BETWEEN 2015 AND 2025), /* Change this ASAP 2025 to current year.Make trigger instead*/
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
    name VARCHAR(255) NOT NULL,
    descr TEXT NOT NULL,
    image_id INT,
    FOREIGN KEY (image_id) REFERENCES Images(id)
);

CREATE TABLE Ingredients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    food_group_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    calories_per_100_units INT NOT NULL,
    CONSTRAINT chk_calories CHECK (calories_per_100_units >= 0),
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

CREATE FUNCTION calculate_calories(recipe_id INT) RETURNS INT
DETERMINISTIC
BEGIN
    /* The function calculates the total calories of a recipe 
    by summing the calories of each ingredient multiplied 
    by the quantity of the ingredient in the recipe */

    DECLARE total_calories INT;

    SELECT SUM(Ingredients.calories_per_100_units * requires.num_units) INTO total_calories
    FROM requires
    JOIN Ingredients ON requires.ingredient_id = Ingredients.id
    WHERE requires.recipe_id = recipe_id;

    RETURN total_calories;
END //

DELIMITER ;


CREATE TABLE DietaryInfo (
    id INT PRIMARY KEY AUTO_INCREMENT,
    recipe_id INT NOT NULL,
    fat_content INT NOT NULL,
    protein_content INT NOT NULL,
    hydrocarbon_content INT NOT NULL,
    calories INT,
    FOREIGN KEY (recipe_id) REFERENCES Recipes(id),
    CONSTRAINT chk_fat_content CHECK (fat_content >= 0),
    CONSTRAINT chk_protein_content CHECK (protein_content >= 0),
    CONSTRAINT chk_hydrocarbon_content CHECK (hydrocarbon_content >= 0)
);

CREATE TABLE Steps (
    id INT PRIMARY KEY AUTO_INCREMENT,
    recipe_id INT,
    step_number TINYINT NOT NULL,
    CONSTRAINT chk_step_number CHECK (step_number > 0),
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
    quantity INT NOT NULL,
    CONSTRAINT pos_quantity CHECK (quantity > 0),
    FOREIGN KEY (recipe_id) REFERENCES Recipes(id)
);

CREATE TABLE Tags (
    id INT PRIMARY KEY AUTO_INCREMENT,
    /* We expect tags to be short*/
    tag_name VARCHAR(45) NOT NULL UNIQUE
    
);

CREATE TABLE chef_recipes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    chef_id INT NOT NULL,
    recipe_id INT NOT NULL,
    CONSTRAINT chk_unique_pair UNIQUE (chef_id, recipe_id),
    FOREIGN KEY (chef_id) REFERENCES Chefs(id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes(id)
);

CREATE TABLE episode_cuisines (
    id INT PRIMARY KEY AUTO_INCREMENT,
    episode_id INT NOT NULL,
    cuisine_id INT NOT NULL,
    CONSTRAINT cuisine_chosen_once UNIQUE (episode_id, cuisine_id),
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

/* Probably not needed 
CREATE TABLE episode_recipes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    episode_id INT NOT NULL,
    recipe_id INT NOT NULL,
    CONSTRAINT recipe_chosen_once UNIQUE (episode_id, recipe_id),
    FOREIGN KEY (episode_id) REFERENCES Episodes(id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes(id)
);
*/

CREATE TABLE requires (
    id INT PRIMARY KEY AUTO_INCREMENT,
    recipe_id INT NOT NULL,
    ingredient_id INT NOT NULL,
    quantity VARCHAR(255) NOT NULL,
    num_units INT NOT NULL,
    main_ingredient BOOLEAN,
    ingr_type VARCHAR(45),
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
    /* A chef can't specialise in the same cuisine twice */
    CONSTRAINT chk_specialisation UNIQUE (chef_id, cuisine_id),
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
    /* A judge can't rate the same contestant twice */
    CONSTRAINT chk_unique_rating UNIQUE (episode_id,judge_id, contestant_id),
    FOREIGN KEY (episode_id) REFERENCES Episodes(id),
    FOREIGN KEY (judge_id) REFERENCES Chefs(id),
    FOREIGN KEY (contestant_id) REFERENCES Chefs(id)
);

CREATE TABLE chefs_recipes_episode (
    id INT PRIMARY KEY AUTO_INCREMENT,
    episode_id INT NOT NULL,
    chef_id INT NOT NULL,
    recipe_id INT NOT NULL,
    /* The triplet (episode_id, chef_id, recipe_id) must be unique */
    CONSTRAINT chk_unique_participation UNIQUE (episode_id, chef_id, recipe_id),
    /* A chef must not participate in three consecutive episodes */
   /* CONSTRAINT chk_consecutive_episodes CHECK ( 
        (SELECT COUNT(*) FROM chefs_recipes_episode
        WHERE chef_id = chef_id
        AND (
            episode_id = episode_id - 1
            OR episode_id = episode_id - 2
            OR episode_id = episode_id - 3
        )
        ) < 3
    ),remember to make this trigger*/
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
    /*CONSTRAINT chk_consecutive_episodes CHECK (
        (SELECT COUNT(*) FROM is_judge
        WHERE judge_id = judge_id
        AND (
            episode_id = episode_id - 1
            OR episode_id = episode_id - 2
            OR episode_id = episode_id - 3
        )
        ) < 3
    ),remember to make this a trigger*/
    FOREIGN KEY (judge_id) REFERENCES Chefs(id),
    FOREIGN KEY (episode_id) REFERENCES Episodes(id)
);

DELIMITER //

CREATE TRIGGER `CalculateCalories` BEFORE INSERT ON `DietaryInfo`
FOR EACH ROW
BEGIN
    SET NEW.calories = calculate_calories(NEW.recipe_id);
END //

CREATE TRIGGER `ReCalculateCalories` BEFORE UPDATE ON `DietaryInfo`
FOR EACH ROW
BEGIN
    SET NEW.calories = calculate_calories(NEW.recipe_id);
END //

DELIMITER ;

DELIMITER //

/* Trigger to set the winner of an episode based on the ratings */
CREATE TRIGGER `SetEpisodeWinner` AFTER INSERT ON `rates`
FOR EACH ROW
BEGIN
    DECLARE winner_id INT;

    SELECT contestant_id INTO winner_id
    FROM rates JOIN chefs
    WHERE episode_id = NEW.episode_id AND chefs.id = contestant_id
    GROUP BY contestant_id
    ORDER BY SUM(score) DESC, prof_certification DESC /* If scores are equal, the chef with the highest certification wins */
    LIMIT 1;

    UPDATE Episodes
    SET winner_id = winner_id
    WHERE id = NEW.episode_id;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER `FixEpisodeWinner` AFTER UPDATE ON `rates`
FOR EACH ROW
BEGIN
    DECLARE winner_id INT;

    SELECT contestant_id INTO winner_id
    FROM rates JOIN chefs
    WHERE episode_id = NEW.episode_id AND chefs.id = contestant_id
    GROUP BY contestant_id
    ORDER BY SUM(score) DESC, prof_certification DESC /* If scores are equal, the chef with the highest certification wins */
    LIMIT 1;

    UPDATE Episodes
    SET winner_id = winner_id
    WHERE id = NEW.episode_id;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER `SetEpisodeCuisine` AFTER INSERT ON `chefs_recipes_episode`
FOR EACH ROW
BEGIN
    DECLARE cus_id INT;

    SELECT cuisine_id INTO cus_id
    FROM chef_recipes
    JOIN Recipes
    ON chef_recipes.recipe_id = Recipes.id
    WHERE chef_recipes.chef_id = NEW.chef_id
    AND Recipes.id = NEW.recipe_id;

    INSERT INTO episode_cuisines (episode_id, cuisine_id)
    VALUES (NEW.episode_id, cus_id);
END //

DELIMITER ;

