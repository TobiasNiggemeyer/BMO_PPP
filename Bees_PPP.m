function [loesung] = Bees_PPP(t_max)
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
if ~exist('t_max','var') t_max = 1000; end

cocktailMatrix = readtable('Cocktail_Database/cocktails.csv');
stockMatrix = readtable('Cocktail_Database/available_ingredients.csv');

x = 6;

% Anzahl Bienen gesamt
ns = 15;
% Die besten und exzellenten Bienen
nb = 4;
ne = 2;

% Die von den besten und exzellenten zu rekrutierenden Bienen
nrb = 2;
nre = 3 ;

% das hier ist ein Problem
% nrbees = zeros(nrb + 1, 1);
% nreees = zeros(nre + 1, 1);

% init zufällige Bienen
rand_bees = createRandomBees(cocktailMatrix,ns,x);

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
            nreees = [nreees, createNeighbourhoodBee(nreees(:,1), cocktailMatrix)];
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
            nreees = [nrees, createNeighbourhoodBee(nrbees(:,1), cocktailMatrix)];                    
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
    
    % übernehme die besten Bienen der lokalen Suche in den Schwarm
    rand_bees(:,1:nb) = B(:,:);
    
    % lasse neue Bienen ausschwärmen    
    rand_bees(:,nb+1:ns) = createRandomBees(cocktailMatrix,ns-nb,x);
    
    % finde die nb besten Bienen für die nächste Iteration

    for i = 1:ns
        f(1,i) = costfunc(rand_bees(:,i), stockMatrix, cocktailMatrix);
    end

    % finde die nb besten Bienen
    [A, I] = maxk(f, nb);
    B = rand_bees(:,I);
    loesung = B(:,1);

    t = t+1;
end
    
    

