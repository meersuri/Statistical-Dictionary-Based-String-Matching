function inspectCode(allCodes)
    NumCodeBooks = size(allCodes,1);
    %inspect generated codebooks code lengths
    Ncodes = zeros(NumCodeBooks,1);
    for i=1:NumCodeBooks
        Ncodes(i) = size(allCodes{i},1);
    end
%     [Ncodes,idx] = sort(Ncodes);
    ftable = tabulate(Ncodes);
    figure;
    plot(ftable);