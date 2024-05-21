import os
import mysql.connector
import random

# Commented Lines were for writing to the DML_SCRIPT.sql file
# Please don't uncomment them unless you want to write to the file.

#$Env:<variable-name> = "<new-value>" - to set environment variable in PowerShell
#$Env:MYSQL_KEY = 'password123' - example

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password=os.environ.get('MYSQL_KEY'),
    database="CookingContest"
)

if __name__ == "__main__":
    #DML = open("DML_SCRIPT.sql", "a")
    #DML.write("\n")
    mycursor = mydb.cursor()
    STARTING_YEAR = int(input("Enter the starting year: "))
    ENDING_YEAR = int(input("Enter the ending year: "))
    SEASON_EPISODES = 10
    last_3_rec = {0: [] , 1: [], 2: []}
    last_3_chefs = {0: [] , 1: [], 2: []}
    last_3_judges = {0: [] , 1: [], 2: []}
    for year in range(STARTING_YEAR, ENDING_YEAR):
        diff = year - STARTING_YEAR
        diff = diff % 2
        persistent_chefs = []
        for episode in range(1, SEASON_EPISODES + 1):
            mycursor.execute("INSERT INTO Episodes (episode_number,year_played) VALUES (%s, %s)", (episode,year))
            #DML.write(f"INSERT INTO Episodes (episode_number,year_played) VALUES ({episode},{year});\n")
            episode_id = mycursor.lastrowid
            mydb.commit()
            print(f"Inserted {year} episode {episode}")
            mycursor.execute("SELECT id FROM Chefs")
            chefs = mycursor.fetchall()
            cuisines_used = []
            recipes_used = []
            chosen_chefs = 0
            contestants = []
            while chosen_chefs < 10:
                avoid_chefs = last_3_chefs[0] + last_3_chefs[1] + last_3_chefs[2] # Avoid repeating chefs
                avoid_recipes = last_3_rec[0] + last_3_rec[1] + last_3_rec[2]
                chefs = [x for x in chefs if x not in avoid_chefs]
                if len(chefs) == 0:
                    continue
                if chosen_chefs < 5:
                    chef = random.choice(chefs)
                else:
                    if len(persistent_chefs) == 0:
                        chef = random.choice(chefs)
                    else:
                        if random.randint(0, 1) == 0:
                            chef = random.choice(chefs)
                        else:
                            chef = random.choice(persistent_chefs)
                if chef in contestants:
                    continue
                mycursor.execute("SELECT recipe_id FROM chef_recipes WHERE chef_id = %s", chef)
                recipes = mycursor.fetchall()
                recipes = [x for x in recipes if x not in avoid_recipes]
                if len(recipes) == 0:
                    continue
                random_recipe = random.choice(recipes)
                mycursor.execute("SELECT cuisine_id FROM Recipes WHERE id = %s", random_recipe)
                threshold = 0
                cuisine = mycursor.fetchone()
                while (cuisine in cuisines_used or random_recipe in avoid_recipes)and threshold < 10:
                    threshold += 1
                    random_recipe = random.choice(recipes)
                    mycursor.execute("SELECT cuisine_id FROM Recipes WHERE id = %s", random_recipe)
                    cuisine = mycursor.fetchone()
                if threshold >= 10:
                    continue
                cuisines_used.append(cuisine)
                recipes_used.append(random_recipe)
                mycursor.execute("INSERT INTO Chefs_Recipes_Episode (chef_id, recipe_id, episode_id) VALUES (%s, %s, %s)", (chef[0], random_recipe[0], episode_id))
                #DML.write(f"INSERT INTO Chefs_Recipes_Episode (chef_id, recipe_id, episode_id) VALUES ({chef[0]}, {random_recipe[0]}, {episode_id});\n")
                chosen_chefs += 1
                contestants.append(chef)
                mydb.commit()
                print(f"Inserted chef {chef[0]} recipe {random_recipe[0]} for episode {episode_id}")
            last_3_rec[0] = last_3_rec[1]
            last_3_rec[1] = last_3_rec[2]
            last_3_rec[2] = recipes_used
            persistent_chefs += last_3_chefs[0][0 : len(last_3_chefs[0])//2]
            last_3_chefs[0] = last_3_chefs[1]
            last_3_chefs[1] = last_3_chefs[2]
            last_3_chefs[2] = contestants
            avoid_judges = last_3_judges[0] + last_3_judges[1] + last_3_judges[2] 
            candidate_judges = [x for x in chefs if x not in contestants and x not in avoid_judges]
            # Take 3 unique judges
            judges = random.sample(candidate_judges, 3)
            while judges in avoid_judges:
                judges = random.sample(candidate_judges, 3)
            for judge in judges:
                mycursor.execute("INSERT INTO is_judge (judge_id, episode_id) VALUES (%s, %s)", (judge[0], episode_id))
                #DML.write(f"INSERT INTO is_judge (judge_id, episode_id) VALUES ({judge[0]}, {episode_id});\n")
                mydb.commit()
                print(f"Inserted judge {judge[0]} for episode {episode_id}")
            last_3_judges[0] = last_3_judges[1]
            last_3_judges[1] = last_3_judges[2]
            last_3_judges[2] = judges
            for contestant in contestants:
                score_1 = random.randint(1, 5)
                score_2 = min(5, score_1 + random.randint(1, 2))
                score_3 = max(1, score_1 - random.randint(1, 2))
                mycursor.execute("INSERT INTO rates (judge_id, contestant_id, episode_id, score) VALUES (%s, %s, %s, %s)", (judges[0][0], contestant[0], episode_id, score_1))
                mycursor.execute("INSERT INTO rates (judge_id, contestant_id, episode_id, score) VALUES (%s, %s, %s, %s)", (judges[1][0], contestant[0], episode_id, score_2))
                mycursor.execute("INSERT INTO rates (judge_id, contestant_id, episode_id, score) VALUES (%s, %s, %s, %s)", (judges[2][0], contestant[0], episode_id, score_3))
                #DML.write(f"INSERT INTO rates (judge_id, contestant_id, episode_id, score) VALUES ({judges[0][0]}, {contestant[0]}, {episode_id}, {score_1});\n")
                #DML.write(f"INSERT INTO rates (judge_id, contestant_id, episode_id, score) VALUES ({judges[1][0]}, {contestant[0]}, {episode_id}, {score_2});\n")
                #DML.write(f"INSERT INTO rates (judge_id, contestant_id, episode_id, score) VALUES ({judges[2][0]}, {contestant[0]}, {episode_id}, {score_3});\n")
                mydb.commit()
                print(f"Inserted scores for contestant {contestant[0]} in episode {episode_id} by judges {judges[0][0]}, {judges[1][0]}, {judges[2][0]}")
            #DML.write("\n")
    #DML.close()
    mycursor.close()
