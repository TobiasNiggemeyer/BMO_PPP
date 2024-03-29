function [bees,bee_count] = createRandomBees(cocktailMatrix,nb,n,bee_count)
    % Aufruf            :   bees = createRandomBees(nb,n,cocktailMatrix)
    % cocktailMatrix    :   [['-','Ingredient_1',......,'Ingredient_X'],['Cocktail_1',3,NaN,...,43],...,['Cocktail_X',3,NaN,...,43]]
    % nb                :   amount of bees   
    % n                 :   amount of recepies of one bee
    % bees              :   [[['CocktailName1', 1, 45, NaN,...,234],.......,['CocktailNameN', 1, 45, NaN,...,234]],...,[['CocktailName1', 1, 45, NaN,...,234],.......,['CocktailNameN', 1, 45, NaN,...,234]]]
    %                       |––––––––––––––––––––––––––––––––––––––  Bee 1 ––––––––––––––––––––––––––––––––––––––|,...,|––––––––––––––––––––––––––––––––––––––  Bee N ––––––––––––––––––––––––––––––––––––––|
    % bee_count         :   count bees from this counter
    % How to use the bees:
    % bees("recepie","Bee")
    % bee1_rec2 = bees(2,1)
    % bee1_rec2(:,"index of ingeredient") --> amount of that ingredient
    
    %Variable declaration
    bees = table();
    cocktailMatrix_size = size(cocktailMatrix);
    amount_of_cocktails = cocktailMatrix_size(1);
    
    for idx = 1 : nb
        %generate vector of nb random integer in the range of 1:amount_of_cocktails
        random_vec = randi([1 amount_of_cocktails],n,1);

        %create bees matrix out of nb random choosen cocktails from cocktailMatrix
        bees = [bees table(cocktailMatrix(random_vec,:))];
        bees.Properties.VariableNames(idx) = "Bee"+bee_count;
        bee_count = bee_count+1;
    end      
end