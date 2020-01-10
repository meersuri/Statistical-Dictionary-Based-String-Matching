function allCodes = genRandomPrefixCode(lmax, p_split, NumCodeBooks)

    pd = makedist('Binomial',1,p_split);
    allCodes = cell(NumCodeBooks,1);
    for n=1:NumCodeBooks

%         if mod(n,1000) == 0 && n <= R/2
%             p1 = p1+0.1*2000/R;
%             pd = makedist('Binomial',1,p1);
%         elseif mod(n,1000) == 0  
%             p1 = p1+0.0049999*2000/R;
%             pd = makedist('Binomial',1,p1);
%         end

        edges = zeros(2^(lmax+1)-1,2^(lmax+1)-1);
        a = sub2ind(size(edges),[1,1,1],[1,2,3]);
        edges(a) = 1;
        usableLeaves = [];
        leaves = zeros(1,2^lmax);

        for i=1:lmax-1
            if i == 1
                usableLeaves = 2^i:2^(i+1)-1;
            end
            ext = logical(random(pd,1,size(usableLeaves,2)));
            a = usableLeaves(ext);
            b = a.*2;
            c = b+1;
            e = (b-1).*size(edges,1)+a;
            f = (c-1).*size(edges,1)+a;
            edges([e,f]) = 1;
            usableLeaves = [b,c];
            if isempty(usableLeaves)
                break;
            end
        end
        k = 1;
        for i=1:lmax
            allLeaves = 2^i:2^(i+1)-1;
            for j=1:size(allLeaves,2)
                x = allLeaves(1,j);
                if i == lmax && edges(floor(x/2),x) == 1 || edges(floor(x/2),x) == 1 && (edges(x,2*x) == 0 && edges(x,2*x+1) == 0) 
                      leaves(k) = x;
                      k = k+1;
                end
            end
        end
        leaves(leaves == 0) = [];
        codes = cell(size(leaves,2),1);
        for i=1:size(leaves,2)
              code = logical(de2bi(leaves(i),'left-msb'));
              codes{i,1} = code(1,2:end);
        end  
        allCodes{n} = codes;
    end
end