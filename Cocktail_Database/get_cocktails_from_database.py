import urllib.request, json, csv
from fractions import Fraction

#defines
number_of_cocktails     = 2

#varialble declaration 
cocktail_matrix_raw     = [[]]
cocktail_matrix_sorted  = [[]] #size will be defined after the quantity of ingredients was counted
number_of_ingredients   = 0
cocktail_ingredients    = ['-']
cocktails_with_ingredients = []

#read in available_ingredients
available_ingredients = []
with open('available_ingredients_2.csv') as csvfile:
    readCSV = csv.reader(csvfile, delimiter=',')
    for row in readCSV:
        available_ingredients.append(str(row[0]).split(':')[0])

#request cocktails which include the available ingredients
for ingredient in available_ingredients:
    print(ingredient)
    with urllib.request.urlopen("https://www.thecocktaildb.com/api/json/v1/1/filter.php?i="+ingredient) as url:
        data = json.loads(url.read().decode())
        for drinks in data['drinks']:
            cocktails_with_ingredients.append(drinks['strDrink'])


#get the ingredients of the cocktail
cocktail_counter = 0
cocktail_matrix_raw     = [[] for x in (range(len(cocktails_with_ingredients)))]
for cocktail in cocktails_with_ingredients:
    cocktail_matrix_raw[cocktail_counter].append(str(cocktail).replace(" ","_"))
    print(str(cocktail).replace(" ","_"))
    with urllib.request.urlopen("https://www.thecocktaildb.com/api/json/v1/1/search.php?s="+str(cocktail).replace(" ","_").replace("é","e")) as url:
        data = json.loads(url.read().decode())
        ingredients_counter = 1
        while 1:
            if data['drinks'][0]['strIngredient'+str(ingredients_counter)] != None and data['drinks'][0]['strMeasure'+str(ingredients_counter)] != None:
                try:
                    quantity = Fraction(str(data['drinks'][0]['strMeasure'+str(ingredients_counter)]).split(' ')[0])             
                    print('')
                    cocktail_ingredient_plus_quantity = data['drinks'][0]['strIngredient'+str(ingredients_counter)].replace(" ","_")
                    cocktail_ingredient_plus_quantity = cocktail_ingredient_plus_quantity+':'
                    cocktail_ingredient_plus_quantity = cocktail_ingredient_plus_quantity+str(float(quantity))
                    cocktail_matrix_raw[cocktail_counter].append(cocktail_ingredient_plus_quantity)
                except:
                    print('Not a quantity')
            else:
                break
            ingredients_counter = ingredients_counter+1
    cocktail_counter = cocktail_counter+1
    
#dummy cocktail (can be delted after api access)
#cocktail_matrix_raw[0]=['Cocktail_1', 'Orangensaft:20', 'Zitronensaft:15', 'Rum:10', 'Wiskey:4', 'Himbeersaft:10']
#cocktail_matrix_raw[1]=['Cocktail_2', 'Zitronensaft:20', 'Gin:15', 'Wiskey:10', 'Vodka:4']

#save the different ingredients in the cocktail_ingredients array
for cocktail in cocktail_matrix_raw:
    for cocktail_ingredient in cocktail:
        if str(cocktail_ingredient).find(':') != -1:
            if str(cocktail_ingredient).split(':')[0].capitalize() not in cocktail_ingredients:
                cocktail_ingredients.append(str(cocktail_ingredient).split(':')[0].capitalize())
                number_of_ingredients = number_of_ingredients+1

#sort the matrix x-axis: ingredients + quantity y-axis: cocktail
#
# -             |Orangensaft    |Rum    |Whiskey.......
#---------------------------------------------------------------
# Cocktail 1    |20             |-      |10
# Cocktail 2    |-              |15     |-
cocktail_matrix_sorted      = [[''for x in range(number_of_ingredients+1)] for x in range(cocktail_counter+1)]
#write ingredients to the cocktail_matrix_sorted matrix
cocktail_matrix_sorted[0]   = cocktail_ingredients
#write cocktail names and quantity of ingredients into matrix
cocktail_idx = 0
for cocktail in cocktail_matrix_raw:
    cocktail_idx = cocktail_idx+1
    cocktail_matrix_sorted[cocktail_idx][0] = cocktail[0]
    for quantity_of_ingredients in cocktail:
        ingredient_idx = 0
        for ingredient in cocktail_matrix_sorted[0]:
            if ingredient == quantity_of_ingredients.split(':')[0].capitalize():
                cocktail_matrix_sorted[cocktail_idx][ingredient_idx] = quantity_of_ingredients.split(':')[1]
            ingredient_idx = ingredient_idx+1

#write matrix to mat file (or any other file which can be included by matlab)
with open("cocktails_2.csv","w+") as my_csv:
    csvWriter = csv.writer(my_csv,delimiter=',')
    csvWriter.writerows(cocktail_matrix_sorted)