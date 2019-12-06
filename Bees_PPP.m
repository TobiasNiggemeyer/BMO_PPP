function [loesung, best_f] = Bees_PPP(t_max)
% Aufruf:    [loesung] = RandomWalk(t_max,d,func,xmin,xmax,ymin,ymax)
% t_max:     maximale Anzahl Iterationen, default: 1000
% d:         maximale Schrittweite,, default: 0.1
% func:      Funktionsargument, default: @fRosenbrock
% xmin:      minimaler Wert f�r x, default: -3
% xmax:      maximaler Wert f�r x, default: 3
% ymin:      minimaler Wert f�r y, default: -3
% ymax:      maximaler Wert f�r y, default: 3
% loesung:   [x_min, y_min, f_min]

% Defaultwerte f�r die Anzahl der Iterationen und Schrittweite
% und der Standard-Funktion
if ~exist('t_max','var') t_max = 50; end

cocktailMatrix = readtable('Cocktail_Database/cocktails.csv');
stockMatrix = readtable('Cocktail_Database/available_ingredients.csv');
format shortg;
c = clock;

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

% das hier ist ein Problem
% nrbees = zeros(nrb + 1, 1);
% nreees = zeros(nre + 1, 1);

% init zufällige Bienen
[rand_bees, bee_count] = createRandomBees(cocktailMatrix,ns,x,bee_count);

f = zeros(1,ns);

for i = 1:ns
    f(1,i) = costfunc(rand_bees(:,i), stockMatrix, cocktailMatrix);
end

% finde die nb besten Bienen
[A, I] = maxk(f, nb);
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
        f(1,i) = costfunc(rand_bees(:,i), stockMatrix, cocktailMatrix);
    end

    % finde die nb besten Bienenus
    [A, I] = maxk(f, nb);
    B = rand_bees(:,I);
    loesung = B(:,1);
    best_f = f(1,1);

    t = t+1;
end
format shortg;
d = clock-c; 
disp(d(1,4:end))
best_f
end
    

