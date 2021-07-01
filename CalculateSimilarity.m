 function [affinity] = CalculateSimilarity(data,graph,sigma,k,epsilon)

%sigma = 0.5;  % for Debeye-Scherrer data
%%sigma=0.07   %for synthetic data
n=size(data,1);
%dist=zeros(n*(n-1)/2,1);
affinity=zeros(n);
dist=zeros(n);

if nargin<2
    g='full';
    sigma=1.0;
else
    g=graph;
end

% for i=1:n
%     for j=i+1:n
%         dist(i,j)=sqrt((data(i,1)-data(j,1))^2 + (data(i,2)-data(j,2))^2);
%         dist(j,i)=dist(i,j);
%     end
% end
dist=squareform(pdist(data,'euclidean'));

switch (g)
    case 'epsilon'
        %  epsilon=13;
        dist<epsilon
        affinity=(dist<epsilon);
        affinity(find(eye(n)))=0;
    case 'knn'
        %knn_dist=zeros(n);
        [nn,d] = knnsearch(data,data,'K',k+1,'Distance','euclidean');
%         affinity(knn)=1./knn_dist;
        for i=1:n
            knn = nn(i,2:k+1); 
            knn_dist = d(i,2:k+1);
            affinity(i,knn) = 1./knn_dist; %exp(-(knn_dist(i,knn(l))^2)/(2*sigma^2))
            affinity(knn,i) =  affinity(i,knn);
        end
         
    case 'mknn'
        
    case 'full'
        size(dist)
        affinity=exp(-(dist.^2)/(2*sigma^2));
        affinity(find(eye(n)))=0;
end

end

