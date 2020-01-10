lmax = 8;
NumCodeBooks = 5000;
N = 10^6;
% p1 = [0.70,0.75,0.80,0.85,0.88,0.91,0.93,0.95,0.97,0.99];
p1 = [0.7,0.8,0.9,0.95];
% p1 = [0.65,0.75,0.85,0.90,0.95];
% p1 = 0.85;
p = 0.6*ones(1,size(p1,2));
q = 0.2*ones(1,size(p1,2));
q_lens = 1:10;


costs = [];
codeBookSizes = [];
minCost = zeros(2^lmax, 1);


for i=1:size(p,2)
    [allCodes,expCost,expTailCost,expHeadCost,expTotalCost] = IRSystem(NumCodeBooks,lmax,N,p(i),q(i),p1(i),q_lens);
    Ncodes = zeros(NumCodeBooks,1);
    for j=1:NumCodeBooks
        Ncodes(j) = size(allCodes{j},1);
    end
    costs = [costs;expTotalCost];
    codeBookSizes = [codeBookSizes;Ncodes];
    Vars{i} = minCost;
end

for i=1:2^lmax
    costM = [];
    for j=1:size(costs,1)
        if codeBookSizes(j) == i
            costM = [costM; costs(j)];
        end
    end
    if size(costM,1) > 0
        minCost(i) = min(costM);
    else
        minCost(i) = NaN;
    end
end

figure;
stem(minCost);
 

