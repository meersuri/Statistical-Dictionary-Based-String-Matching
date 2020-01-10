function Queries = genQueries(q_lens)
    Queries = cell(size(q_lens,2),1);
    for i=1:size(q_lens,2)
        q1 = cell(2^q_lens(i),1);
        for j=1:2^q_lens(i)
            q1{j} = logical(de2bi(j-1,q_lens(i),'left-msb'));
        end
        Queries{i} = q1;
    end
end