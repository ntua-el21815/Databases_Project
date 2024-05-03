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
        for i in range(1, len(recipes_info) + 1):
            needed_image = ""
            for file in files:
                if file.startswith("Recipe_" + str(i)):
                    needed_image = file
                    break
            image_path = os.path.join(search_path + "\\" + needed_image).replace("\\","\\\\")
            cursor.execute(f"INSERT INTO Images (image,descr) VALUES (LOAD_FILE('{image_path}') , '{recipes_info[i-1]['name']}');")
            cursor.execute(f"UPDATE Recipes SET image_id = {i} WHERE id = {i};")
        mydb.commit()
        cursor.close()
    except Exception as e:
        mydb.rollback()
        cursor.close()
        #Raise an exception
        raise e
            
            