function [cost] = costfunc(bee,stock)

    % get count of different ingredients
    n_stock = sum(logical(stock));

    % see, if all stocked ingredients are used by bee
    n_check = sum(~all(bee == 0) & stock);

    % if bee doesn't use all stocked ingredients, return n_check
    if(n_check < n_stock)
        cost = n_check;
    else
        % get highest possible amount of cocktails 
        amount = getCocktailCount(bee, stock);
        % get amount of ingredients to buy
        toBuy = getIngredientQuantity(bee, stock, amount);
        cost = n_stock + amount - toBuy;
    end

end

