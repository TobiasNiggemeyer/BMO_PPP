function neigbourbee = createNeighbourhoodBee(bee, cocktailMatrix)
    % Aufruf            :   neigbourbee = createNeighbourhoodBee(bee)
    % cocktailMatrix    :   table with all available cocktails (create *.csv file with get_cocktails_from_database.py)
    % bee               :   table of one Bee with x recepies (create bees with createRandomBees function)
    % Example           :   neighbourbee = createNeighbourhoodBee(rand_bee(:,1))
    
    % neigbourbee       :   table of a Bee with x recepies
    
    % select random recepie from bee
    bee_size = size(bee);
    amount_of_recepies_in_bee = bee_size(1);
    random_recepie_bee_cnt = randi([1 amount_of_recepies_in_bee]);

    % select random cocktail out of the cocktailMatrix
    cocktailMatrix_size = size(cocktailMatrix);
    amount_of_cocktails = cocktailMatrix_size(1);
    while true
        random_recepie_cnt = randi([1 amount_of_cocktails]);
        rand_cocktail = cocktailMatrix(random_recepie_cnt,:);
        
        for recepies_idx = 1:amount_of_recepies_in_bee
            if isequal(bee{random_recepie_bee_cnt,1}, rand_cocktail(1,1))
               break; 
            end
        end
        
        if recepies_idx == amount_of_recepies_in_bee
           break; 
        end
    end
    
    % exchange the recepies of the bee
    bee(random_recepie_bee_cnt,1) = table(rand_cocktail);
    neigbourbee = bee;
end