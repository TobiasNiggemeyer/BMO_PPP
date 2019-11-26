function [quant] = getIngredientQuantity(bee, stock, amount)

% get ingredients that are required but not stocked
ingredients = bee(:,stock == 0);
% calculate needed amount of each not stocked ingredient and sum'en all up
quant = sum(sum(amount .* ingredients));

end

