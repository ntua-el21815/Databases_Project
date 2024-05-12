import os
import mysql.connector
import random

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password=os.environ.get('MYSQL_KEY'),
    database="CookingContest"
)

if __name__ == "__main__":
    mycursor = mydb.cursor()
    STARTING_YEAR = 2018
    ENDING_YEAR = 2024
    SEASON_EPISODES = 10
    for year in range(STARTING_YEAR, ENDING_YEAR):
        for episode in range(1, SEASON_EPISODES + 1):
            mycursor.execute("INSERT INTO Episodes (episode_number,year_played) VALUES (%s, %s)", (episode,year))
            episode_id = mycursor.lastrowid
            mydb.commit()
            print(f"Inserted {year} episode {episode}")
            mycursor.execute("SELECT id FROM Chefs")
            chefs = mycursor.fetchall()
            cuisines_used = []
            chosen_chefs = 0
            contestants = []
            while chosen_chefs < 11:
                chef = random.choice(chefs)
                if chef in contestants:
                    continue
                mycursor.execute("SELECT recipe_id FROM chef_recipes WHERE chef_id = %s", chef)
                recipes = mycursor.fetchall()
                random_recipe = random.choice(recipes)
                mycursor.execute("SELECT cuisine_id FROM Recipes WHERE id = %s", random_recipe)
                threshold = 0
                cuisine = mycursor.fetchone()
                while cuisine in cuisines_used and threshold < 10:
                    threshold += 1
                    random_recipe = random.choice(recipes)
                    mycursor.execute("SELECT cuisine_id FROM Recipes WHERE id = %s", random_recipe)
                    cuisine = mycursor.fetchone()
                if threshold >= 10:
                    continue
                cuisines_used.append(cuisine)
                mycursor.execute("INSERT INTO Chefs_Recipes_Episode (chef_id, recipe_id, episode_id) VALUES (%s, %s, %s)", (chef[0], random_recipe[0], episode_id))
                chosen_chefs += 1
                contestants.append(chef)
                mydb.commit()
                print(f"Inserted chef {chef[0]} recipe {random_recipe[0]} for episode {episode_id}")
            candidate_judges = [x for x in chefs if x not in contestants]
            # Take 3 unique judges
            judges = random.sample(candidate_judges, 3)
            for judge in judges:
                mycursor.execute("INSERT INTO is_judge (judge_id, episode_id) VALUES (%s, %s)", (judge[0], episode_id))
                mydb.commit()
                print(f"Inserted judge {judge[0]} for episode {episode_id}")
            for contestant in contestants:
                score_1 = random.randint(1, 5)
                score_2 = min(5, score_1 + random.randint(1, 2))
                score_3 = max(1, score_1 - random.randint(1, 2))
                mycursor.execute("INSERT INTO rates (judge_id, contestant_id, episode_id, score) VALUES (%s, %s, %s, %s)", (judges[0][0], contestant[0], episode_id, score_1))
                mycursor.execute("INSERT INTO rates (judge_id, contestant_id, episode_id, score) VALUES (%s, %s, %s, %s)", (judges[1][0], contestant[0], episode_id, score_2))
                mycursor.execute("INSERT INTO rates (judge_id, contestant_id, episode_id, score) VALUES (%s, %s, %s, %s)", (judges[2][0], contestant[0], episode_id, score_3))
                mydb.commit()
                print(f"Inserted scores for contestant {contestant[0]} in episode {episode_id} by judges {judges[0][0]}, {judges[1][0]}, {judges[2][0]}")
    mycursor.close()
