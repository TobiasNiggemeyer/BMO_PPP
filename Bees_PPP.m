function [loesung] = Bees_PPP(t_max)

% Defaultwerte fuer die Anzahl der Iterationen
if ~exist('t_max','var') t_max = 500; end

cocktailMatrix = readtable('Cocktail_Database/cocktails_1.csv');
stockMatrix = readtable('Cocktail_Database/available_ingredients_1.csv');

% benötigte Zeit für die Optimierung
format shortg;
c = clock;

% Anzahl an verschiedenen Cocktails in einer Biene
x = 5;
% Anzahl Bienen gesamt
ns = 15;
% Die besten und exzellenten Bienen
nb = 4;
ne = 2;

% Benennung der Bienen hochzählen
bee_count = 0;

% Die von den besten und exzellenten zu rekrutierenden Bienen
nrb = 2;
nre = 3 ;

%vector for the loss value of the best bee per iteration
best_loss_f = [];
best_amount_f = [];
best_tobuy_f = [];

% init zufällige Bienen
[rand_bees, bee_count] = createRandomBees(cocktailMatrix,ns,x,bee_count);

f = zeros(3,ns);

for i = 1:ns
    [f(1,i), f(2,i), f(3,i)] = costfunc(rand_bees(:,i), stockMatrix, cocktailMatrix);
end

% finde die nb besten Bienen
[A, I] = maxk(f(1,:), nb);
B = rand_bees(:,I);
loesung = B(:,1);

t = 1;

while(t < t_max)
    % zuerst betrachte die exzellenten Bienen
    for i = 1:ne
        nreees = B(:,i);
        % lasse die nre exzellenten Folgebienen ausschwärmen
        for j = 2:nre+1    
            [newbee, bee_count] = createNeighbourhoodBee(nreees(:,1), cocktailMatrix, bee_count);
            nreees = [nreees, newbee];
        end        
        % wähle die beste der Folgebienen inkl der exzellenten Biene        
        temp_fin = 0;
        for j=1:nre+1
            temp = costfunc(nreees(:,j), stockMatrix, cocktailMatrix);
            if temp > temp_fin 
                B(:,i) = nreees(:,j);
                temp_fin = temp;
            end
        end
    end
    % dann betrachte die übrigen guten Bienen
    for i = ne+1:nb
        nrbees = B(:,i);    
        % lasse die nrb guten Folgebienen ausschwärmen
        for j = 2:nrb+1            
            [newbee, bee_count] = createNeighbourhoodBee(nrbees(:,1), cocktailMatrix, bee_count);
            nrbees = [nrbees, newbee];                   
        end
        % wähle die beste der Folgebienen inkl der guten Biene
        temp_fin = 0;
        for j=1:nrb+1
            temp = costfunc(nrbees(:,j), stockMatrix, cocktailMatrix);
            if temp > temp_fin 
                B(:,i) = nrbees(:,j);
                temp_fin = temp;
            end
        end
    end
    
    
    rand_bees = table();
    % übernehme die besten Bienen der lokalen Suche in den Schwarm
    rand_bees(:,1:nb) = B(:,:);
    rand_bees.Properties.VariableNames(1:nb) = string(B(1,:).Properties.VariableNames);
    
    % lasse neue Bienen ausschwärmen    
    [temp_bees,bee_count] = createRandomBees(cocktailMatrix,ns-nb,x, bee_count);
    rand_bees(:,nb+1:ns) = temp_bees(:,:);
    rand_bees.Properties.VariableNames(nb+1:ns) = string(temp_bees(1,:).Properties.VariableNames);
    % finde die nb besten Bienen für die nächste Iteration

    for i = 1:ns
        [f(1,i), f(2,i), f(3,i)] = costfunc(rand_bees(:,i), stockMatrix, cocktailMatrix);
    end

    % finde die nb besten Bienenus
    [A, I] = maxk(f(1,:), nb);
    B = rand_bees(:,I);
    loesung = B(:,1);
        
    %save lost value best bee of iteration 
    best_loss_f = [best_loss_f,max(f(1,:))];
    best_amount_f = [best_amount_f, f(2,I(1))];
    best_tobuy_f = [best_tobuy_f, f(3,I(1))];

    % plot the best bee
    figure(1)
    plot(best_loss_f);
    xlabel("Generation");
    ylabel("costfunc(bestBee)");
    figure(2)
    yyaxis left
    plot(best_amount_f);
    xlabel("Generation");
    ylabel("Anzahl an Cocktails")
    yyaxis right
    plot(best_tobuy_f);
    ylabel("Zuzukaufende Menge")
    t = t+1;
end
format shortg;
d = clock-c; 
disp(d(1,4:end))
end
    

