function [allCodes,expCost,expTailCost,expHeadCost,expTotalCost,parses] = IRSystem(NumCodeBooks,lmax,N,p,q,p_split,q_lens)

%     lmax = 6;
%     R = 10000;
%     N = 10^6;
%     p = 0.7;
%     p1 = 0.85;
%     q = 0.2;
%     ql = (1:9);
    
    
    %generate prefix codes by random node splitting in the code tree
    allCodes = genRandomPrefixCode(lmax, p_split, NumCodeBooks);
    
    %generate all binary queries upto max query length
    Queries = genQueries(q_lens);
    
    %precompute codeword hamming weights and lengths for use in 
    %calculation of expected posting list length
    lwt = zeros(NumCodeBooks,2^lmax,2);

    for i=1:NumCodeBooks
        for j=1:size(allCodes{i},1)
            lwt(i,j,1) = size(allCodes{i}{j},2);
            lwt(i,j,2) = sum(allCodes{i}{j});
        end
    end
    
    %Compute expected posting list lengths
    El = zeros(NumCodeBooks,2^lmax,1);

    for i=1:NumCodeBooks
        for j=1:size(allCodes{i},1)
            El(i,j,1) = N*p^lwt(i,j,2)*(1-p)^(lwt(i,j,1) - lwt(i,j,2));
        end
    end
    
    
    %parse all queries and calculate the cost of each parsing
    [costs,tailCosts,headCosts,totalCosts,parses] = parseQueries(allCodes,NumCodeBooks,N,Queries,q_lens,El,lwt);
    
    
    %Take expected value of costs
    [expCost,expTailCost,expHeadCost,expTotalCost] = calcExpCosts(Queries,q_lens,q,NumCodeBooks,costs,tailCosts,headCosts,totalCosts);

end