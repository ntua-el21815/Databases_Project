import json
import os
import mysql.connector

#$Env:<variable-name> = "<new-value>" - to set environment variable in PowerShell
#$Env:Foo = 'An example' - example
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
        for i in range(0, len(recipes_info)):
            needed_image = ""
            for file in files:
                if file.startswith("Recipe_" + str(i + 1)):
                    needed_image = file
                    break
            image_path = os.path.join(search_path + "\\" + needed_image).replace("\\","\\\\")
            cursor.execute(f"INSERT INTO Images (image,descr) VALUES (LOAD_FILE('{image_path}') , '{recipes_info[i]['name']}');")
            cursor.execute(f"UPDATE Recipes SET image_id = {i + 1} WHERE id = {i + 1};")
        mydb.commit()
        cursor.close()
    except Exception as e:
        print(e)
        mydb.rollback()
        cursor.close()
            
            