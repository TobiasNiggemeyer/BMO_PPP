function [loesung] = Bees_test(t_max, d, func, xmin, xmax, ymin, ymax)
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
if ~exist('d','var') d = 1; end
if ~exist('func','var') func = @fRosenbrock; end
if ~exist('xmin','var') xmin = -3; end
if ~exist('xmax','var') xmax = 3; end
if ~exist('ymin','var') ymin = -3; end
if ~exist('ymax','var') ymax = 3; end

% Anzahl Bienen gesamt
ns = 15;
% Die besten und exzellenten Bienen
nb = 4;
ne = 2;

% Die von den besten und exzellenten zu rekrutierenden Bienen
nrb = 2;
nre = 3 ;
nrbees = zeros(nrb + 1, 2);
nreees = zeros(nre + 1, 2);

% init zufällige Bienen
s = zeros(ns,2);
s(:,1) = random('unif',xmin, xmax, ns, 1);
s(:,2) = random('unif',ymin, ymax, ns, 1);

% finde die nb besten Bienen
f = func(s(:,1), s(:,2));
[A, I] = mink(f, nb);
B = s(I,:);
loesung = B(1,:);

t = 1;

while(t < t_max)
    % zuerst betrachte die exzellenten Bienen
    for i = 1:ne
        nreees(1,:) = B(i,:);
        % lasse die nre exzellenten Folgebienen ausschwärmen
        for j = 2:nre+1
            nreees(j,1) = nreees(1,1) + random('unif', -d, d);
            nreees(j,2) = nreees(1,2) + random('unif', -d, d);                    
        end        
        % wähle die beste der Folgebienen inkl der exzellenten Biene
        B(i,:) = nreees(getBestIndexMin(func(nreees(:,1), nreees(:,2))),:);        
    end
    % dann betrachte die übrigen guten Bienen
    for i = ne:nb
        nrbees(1,:) = B(i,:);    
        % lasse die nrb guten Folgebienen ausschwärmen
        for j = 2:nrb+1            
            nrbees(j,1) = nrbees(1,1) + random('unif', -d, d);
            nrbees(j,2) = nrbees(1,2) + random('unif', -d, d);                    
        end
        % wähle die beste der Folgebienen inkl der guten Biene
        B(i,:) = nrbees(getBestIndexMin(func(nrbees(:,1), nrbees(:,2))),:); 
    end
    
    % übernehme die besten Bienen der lokalen Suche in den Schwarm
    s(1:nb,:) = B(:,:);
    
    % lasse neue Bienen ausschwärmen
    s(nb+1:ns, 1) = random('unif',xmin, xmax, ns-nb, 1);
    s(nb+1:ns, 2) = random('unif',ymin, ymax, ns-nb, 1);
    
    % finde die nb besten Bienen für die nächste Iteration
    f = func(s(:,1), s(:,2));
    [A, I] = mink(f, nb);
    B = s(I,:);
    loesung = B(1,:);
    
    t = t+1;
end
    
    

