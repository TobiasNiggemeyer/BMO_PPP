%read in cocktail Matrix
cocktailMatrix = readtable('Cocktail_Database/cocktails.csv');

%read in ingredients Matrix
stockMatrix = readtable('Cocktail_Database/available_ingredients.csv');

%create 5 random bees with 6 recepies
rand_bees = createRandomBees(cocktailMatrix,5,6);

%create neighbour bee of bee number 1
neighbourBee = createNeighbourhoodBee(rand_bees(:,1), cocktailMatrix);