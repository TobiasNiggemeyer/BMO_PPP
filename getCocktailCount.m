function [amounts] = getCocktailCount(bee, stock)
    
    % vector with -1 for liner equation sytem
    x = ones(1,size(bee,1)) * -1;
    % get highest possible count of cocktails (aka Cocktail-Problem)
    amounts = floor(linprog(x, bee(:,stock > 0)', stock(stock > 0)));
end

