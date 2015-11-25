function similarity = compare_similarity(S,M)
[m,n]=size(S);
similarity=0;
for i=1:n
    similarity=similarity+((S(i)-M(i)).^2)/(S(i)+M(i)+1);
end
end

