function labels=spectral_clustering (data,num_clusters,sigma,method,g,k,epsilon)
if nargin<4
    method='njw';
    g='full'
    k=0;
    epsilon=0;
end
IDX=[];
    affinity = CalculateSimilarity(data,g,sigma);
    if (affinity==affinity')
        disp('Affinity OK')
    else
        error('Affinity not symmetric')
    end
%     imagesc(affinity);
%     p=symrcm(affinity);
%     A=affinity(p,p);
% %     figure, imagesc(A)
%     A=affinity(1:30,1:30);
%     G=graph(A);
%     figure,plot(G,'NodeColor','blue','EdgeColor','green')
    switch method
        case 'shi'
            [IDX,C]=cluster_Shi_Malik(affinity, num_clusters);
        case 'njw'
            [IDX,C]=cluster_Ng_Jordan_Weiss(affinity, num_clusters);
    end
  labels=IDX;

% tit=['Spectral Clustering Results using ' method ' (k=',string(num_clusters),', sigma=',string(sigma),')'];
% filename=['..\Results\26042019\',tit,'.png'];
% saveas(gcf,filename,'png');
end
