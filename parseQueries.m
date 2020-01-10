function [costs,tailcosts,headcosts,totalcosts,parses] = parseQueries(allCodes,NumCodeBooks,N,Queries,q_lens,El,lwt)
    
    costs = zeros(NumCodeBooks,size(q_lens,2),2^q_lens(end));
    tailcosts = zeros(NumCodeBooks,size(q_lens,2),2^q_lens(end));
    headcosts = zeros(NumCodeBooks,size(q_lens,2),2^q_lens(end));
    totalcosts = zeros(NumCodeBooks,size(q_lens,2),2^q_lens(end));
    parses = cell(NumCodeBooks,1);
    for i=1:NumCodeBooks
        parse1 = cell(size(q_lens,2),1);
        for j=1:size(q_lens,2)
            parse2 = cell(q_lens(j)+1,1);
            for k=1:2^q_lens(j)
                cost1 = 0;
                cost2 = 0;
                cost3 = 0;
                parse3 = [];
                query = Queries{j}{k};
                query_length = size(query,2);
                code_lens = lwt(i,1:size(allCodes{i},1),1);
%                 clmax = max(cl);
                if query_length <= code_lens(1)
                    %head underflow
                    for m=1:size(allCodes{i},1)
                        if query == allCodes{i}{m}(1,1:query_length)
                            cost1 = cost1 + log(El(i,m,1));
%                             headcosts(i,j,k) = headcosts(i,j,k) + log(El(i,m,1));
                            parse3 = [parse3,-m];
                        end
                    end
                else
                    x = 1;
                    match = true;
                    parselen = 0;
                    while(x < query_length)
                        while match
                            for m=1:size(allCodes{i},1)
                                if (x + code_lens(m) - 1) > query_length
                                    match = false;
                                    break;
                                elseif query(x:x + code_lens(m) - 1) == allCodes{i}{m}
                                    match = true;
                                    cost2 = cost2 + log(El(i,m,1));
                                    x = x + code_lens(m);
                                    parselen = parselen + code_lens(m);
                                    parse3 = [parse3,-m];
                                    break;
                                end
                            end
                        end
                        if parselen < query_length
                            %tail underflow
                            rem = query_length-x+1;
                            index = code_lens>rem;
                            stidx = find(index);
                            st = stidx(1);
                            for m=st:size(allCodes{i},1)
                                if query(x:end) == allCodes{i}{m}(1,1:rem)
                                    cost3 = cost3 + log(El(i,m,1));
%                                     tailcosts(i,j,k) = tailcosts(i,j,k) + log(El(i,m,1));
                                    parse3 = [parse3,-m];
                                end
                            end
                            x = query_length;
                        end
                     end
                end
                costs(i,j,k) = cost2/log(N);
                tailcosts(i,j,k) = cost3/log(N);
                headcosts(i,j,k) = cost1/log(N);
                totalcosts(i,j,k) = (cost1+cost2+cost3)/log(N);
                parse2{k} = parse3;
            end
            parse1{j} = parse2;
        end 
        parses{i} = parse1; 
    end
end
 