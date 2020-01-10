function [out] = modelRLEcode_v2(lmax,N,p,q,ql,B,Bp)

%   lmax = 4;
%   N = 10^6;
%   B = 4;
%   Bp = 0.8;
%   p = 0.3;
%   q = 0.8;
%   ql = 1:10;

    Mmax = lmax;
    R = 2^Mmax;
    allCodes = cell(R,1);
    codebook = cell(R,1);
    
    for j=1:R
        q1 = cell(j,1);
        for i=1:j-1
            q1{i} = logical([zeros(1,i-1),1]);
        end
        q1{j} = zeros(1,j-1,'logical');
        codebook{j} = q1;
    end
    allCodes = codebook;

    Ncodes = zeros(R,1);
    for i=1:R
        Ncodes(i) = size(allCodes{i},1);
    end
    [Ncodes,idx] = sort(Ncodes);
    ftable = tabulate(Ncodes);

    %generate and parse queries


%     pdquery = makedist('Binomial',1,q);
    plength = geopdf(0:B-1,Bp)';
    plength = plength/sum(plength);
    Q = cell(B,1);

    q1 = cell(0,1);
    for i=1:size(ql,2)
        q1 = [q1;logical([zeros(1,ql(i)-1),1])];
    end
    Q{1} = q1;

    for x=2:B
        q2 = cell(0,1);
        for i=1:size(ql,2)
            for j=1:size(Q{x-1},1)
                q2 = [q2;logical([Q{1}{i},Q{x-1}{j}])];
            end
            Q{x} = q2;
        end
    end

    
    lwt = zeros(2^Mmax,2^Mmax,2);

    for i=2:2^Mmax
        for j=1:i
            lwt(i,j,1) = size(allCodes{i}{j},2);
            lwt(i,j,2) = sum(allCodes{i}{j});
        end
    end

    El = zeros(2^Mmax,2^Mmax,1);

    for i=2:2^Mmax
        for j=1:i
            El(i,j,1) = N*p^lwt(i,j,2)*(1-p)^(lwt(i,j,1) - lwt(i,j,2));
        end
    end
    
    zerolists = find(El<1);
    El(zerolists) = 1;


    costs = zeros(R,size(Q,1),size(Q{B},1));
    for i=2:R
        for j=1:size(Q,1)
            for k=1:size(Q{j},1)
                cost = 0;
                query = Q{j}{k};
%                 qlength = size(query,2);
                M = size(allCodes{i},1);
                onepos = find(query);
                idx1 = [onepos,0]-[0,onepos];
                rl = idx1(1:end-1);
                for m=1:size(rl,2)
                    if rl(m)>M-1
                        nZ = floor((rl(m)-1)/(M-1));
                        Rx = rl(m)-(M-1)*nZ;
                        cost = cost + nZ*log(El(i,M,1)) + log(El(i,Rx,1));
                    else
                        cost = cost + log(El(i,rl(m),1));
                    end
                end
                costs(i,j,k) = cost/log(N);
            end
        end
    end
            
           
    %calculate and average costs

    fidx = ftable(:,2);
    fidx = [fidx;zeros(2^lmax-size(fidx,1),1)];
    codeindex = cumsum(fidx);
    avgCost = zeros(R,1);
    qwt = zeros(size(Q,1),size(Q{B},1));
    pquery = zeros(size(Q,1),size(Q{B},1));

    for i=1:size(Q,1)
        for j=1:size(Q{i},1)
            qwt(i,j) = sum(Q{i}{j});
            pquery(i,j) = q^qwt(i,j)*(1-q)^(size(Q{i}{j},2)-qwt(i,j));
        end
        disp(sum(pquery(i,:)));
        pquery(i,:) = pquery(i,:)/sum(pquery(i,:));
    end
    
    EZ = zeros(R,1);
    Zdist = zeros(R,size(Q{1},1));
    for i=2:R
        M = size(allCodes{i},1);
        for j=1:size(Q{1},1)
            Zdist(i,j) = floor(j/(M-1))*pquery(1,j);
            EZ(i) = sum(Zdist(i,:));
        end
    end
        
    
    for i=1:R
        wtcost11 = squeeze(costs(i,:,:)).*pquery;
        wtcost21 = zeros(size(Q,1),1);

        for j=1:size(Q,1)
            wtcost21(j) = sum(wtcost11(j,:));

        end
        avgCost(i) = sum(wtcost21.*plength);

    end



   
    out = cell(5,1);
    out{1} = 1;
    out{2} = lwt;
    out{3} = El;
    out{4} = Q;
    out{5} = avgCost;
    out{6} = EZ;

    return 
end