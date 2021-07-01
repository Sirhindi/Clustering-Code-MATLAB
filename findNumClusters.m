function k=findNumClusters(eigVals,heur)
%%% Finds the number of clusters k using eigen gap heuristic
e = eigVals;
m=size(e,1);
% temp=mean(e)
% a=abs(real(floor(log10(temp))));
diff=[];
switch (heur)
    case 'eigengap'
        k=1;
        format long;
        for l=1:size(e,1)-1
%             maximum=max(diff);
            if (round(e(m),14) - round(e(m-1),14))>0
                diff(l) = round(abs(e(m) - e(m-1)),14)
                if diff(l)< max(diff)
                    [~,k]= max(diff) %l-1
                    break;  
                end
            end
            m=m-1;
        end
    case 'multiplicity'
%       temp=find(eigVals>0.999999999999999)
        temp=find(round(eigVals,14)==1)
        k=length(temp);
end
diff'
end