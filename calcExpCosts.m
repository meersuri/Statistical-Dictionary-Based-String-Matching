function [expCost,expTailCost,expHeadCost,expTotalCost] = calcExpCosts(Queries,q_lens,q,NumCodeBooks,costs,tailCosts,headCosts,totalCosts)

    lambda = mean(q_lens);
    pdlength = makedist('Poisson',lambda);
    plength = pdf(pdlength,q_lens)';
    plength = plength/sum(plength);
    
    qwt = zeros(size(q_lens,2),2^q_lens(end));
    pquery = zeros(size(q_lens,2),2^q_lens(end));
    
    expCost = zeros(NumCodeBooks,1);
    expTailCost = zeros(NumCodeBooks,1);
    expHeadCost = zeros(NumCodeBooks,1);
    expTotalCost = zeros(NumCodeBooks,1);
    
    for i=1:size(q_lens,2)
        for j=1:2^q_lens(i)
            qwt(i,j) = sum(Queries{i}{j});
            pquery(i,j) = q^qwt(i,j)*(1-q)^(q_lens(i)-qwt(i,j));
        end
    end

    for i=1:NumCodeBooks
        wtcost11 = squeeze(costs(i,:,:)).*pquery;
        wtcost12 = squeeze(tailCosts(i,:,:)).*pquery;
        wtcost13 = squeeze(headCosts(i,:,:)).*pquery;
        wtcost14 = squeeze(totalCosts(i,:,:)).*pquery;
        wtcost = zeros(size(q_lens,2),1);
        wtcostHead = zeros(size(q_lens,2),1);
        wtcostTail = zeros(size(q_lens,2),1);
        wtcostTotal = zeros(size(q_lens,2),1);
        for j=1:size(q_lens,2)
            wtcost(j) = sum(wtcost11(j,:));
            wtcostHead(j) = sum(wtcost12(j,:));
            wtcostTail(j) = sum(wtcost13(j,:));
            wtcostTotal(j) = sum(wtcost14(j,:));
        end
        expCost(i) = sum(wtcost.*plength);
        expTailCost(i) = sum(wtcostHead.*plength);
        expHeadCost(i) = sum(wtcostTail.*plength);
        expTotalCost(i) = sum(wtcostTotal.*plength);
%         disp(expTotalCost(i));
    end
end
    