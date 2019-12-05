function [cost] = costfunc(beeMatrix,stockMatrix,cocktailMatrix)

    %get size of cocktailMatrix
    [cocktails_cnt, ingredients_cnt] = size(cocktailMatrix);
    
    %vector with the length of the ingredients 
    stock = zeros(1,ingredients_cnt);
    
    %get size of stockMatrix
    [stock_cnt, amount_cnt] = size(stockMatrix);
    
    %write stock amount into respective cells
    for idx=1:stock_cnt
        stock_idx = find(strcmpi(cocktailMatrix.Properties.VariableNames,stockMatrix{idx,1}(1,1)));
        stock(1,stock_idx) = stockMatrix{idx,2}(1,1);
    end
    
    % get size of bee
    [n, temp] = size(beeMatrix);
    
    for idx=1:n
        table = beeMatrix{idx,1}(1,2:end);
        bee = [bee; table2array(table)];
    end
    
    %replace NaN with 0
    bee(isnan(bee)) = 0;
    


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

