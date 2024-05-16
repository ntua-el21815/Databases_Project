import json
import os
import mysql.connector

#$Env:<variable-name> = "<new-value>" - to set environment variable in PowerShell
#$Env:MYSQL_KEY = 'password123' - example

pswrd = os.getenv("MYSQL_KEY")

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password= pswrd,
    database="CookingContest"
)

with open("Recipes.json", "r", encoding="utf-8") as f1:
    try:
        search_path = os.path.join(os.getcwd(), "Images")
        files = list(filter(lambda x: x.endswith(".jpg") or x.endswith(".jpeg") or x.endswith(".png") or x.endswith(".webp"), os.listdir(search_path)))
        recipes_info = json.load(f1)
        cursor = mydb.cursor()
        for i in range(1, len(recipes_info) + 1):
            needed_image = ""
            for file in files:
                if file.startswith("Recipe_" + str(i)):
                    needed_image = file
                    break
            print(needed_image)
            image_path = os.path.join(search_path + "\\" + needed_image).replace("\\","\\\\")
            cursor.execute(f"INSERT INTO Images (id,image,descr) VALUES ({i},LOAD_FILE('{image_path}') , '{recipes_info[i-1]['name']}');")
        for i in range(1, len(recipes_info) + 1):
            cursor.execute(f"UPDATE Recipes SET image_id = {i} WHERE id = {i};")
        image_path = os.path.join(search_path + "\\chefAvatar.png").replace("\\","\\\\")
        cursor.execute(f"INSERT INTO Images (image,descr) VALUES (LOAD_FILE('{image_path}') , 'Chef Avatar');")
        image_id = len(recipes_info) + 1
        cursor.execute(f"UPDATE Chefs SET image_id = {image_id};")
        image_path = os.path.join(search_path + "\\ingredientPlaceholder.png").replace("\\","\\\\")
        cursor.execute(f"INSERT INTO Images (image,descr) VALUES (LOAD_FILE('{image_path}') , 'Ingredient Placeholder');")
        image_id += 1
        cursor.execute(f"UPDATE Ingredients SET image_id = {image_id};")
        image_path = os.path.join(search_path + "\\EpisodePlaceholder.jpg").replace("\\","\\\\")
        cursor.execute(f"INSERT INTO Images (image,descr) VALUES (LOAD_FILE('{image_path}') , 'Episode Placeholder');")
        image_id += 1
        cursor.execute(f"UPDATE Episodes SET image_id = {image_id};")
        for i in range(1,38):
            for file in files:
                if file.startswith("Theme_ (" + str(i) + ")"):
                    print(file)
                    image_path = os.path.join(search_path + "\\" + file).replace("\\","\\\\")
                    cursor.execute(f"SELECT name FROM Themes WHERE id = {i};")
                    theme_name = cursor.fetchone()[0]
                    cursor.execute(f"INSERT INTO Images (image,descr) VALUES (LOAD_FILE('{image_path}') , '{theme_name}');")
                    image_id = cursor.lastrowid
                    cursor.execute(f"UPDATE Themes SET image_id = {image_id} WHERE id = {i};")
        for i in range(1, 12):
            for file in files:
                if file.startswith("Food_group (" + str(i) + ")"):
                    print(file)
                    image_path = os.path.join(search_path + "\\" + file).replace("\\","\\\\")
                    cursor.execute(f"SELECT name FROM FoodGroups WHERE id = {i};")
                    group_name = cursor.fetchone()[0]
                    cursor.execute(f"INSERT INTO Images (image,descr) VALUES (LOAD_FILE('{image_path}') , '{group_name}');")
                    image_id = cursor.lastrowid
                    cursor.execute(f"UPDATE FoodGroups SET image_id = {image_id} WHERE id = {i};")
        mydb.commit()
        cursor.close()
    except Exception as e:
        mydb.rollback()
        cursor.close()
        #Raise an exception
        raise e
            
            