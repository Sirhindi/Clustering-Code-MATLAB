function [IDX,C]=cluster_Ng_Jordan_Weiss(affinity,num_clusters)
% Ng, A., Jordan, M., and Weiss, Y. (2002). On spectral clustering: analysis and an algorithm. In T. Dietterich,
% S. Becker, and Z. Ghahramani (Eds.), Advances in Neural Information Processing Systems 14 
% (pp. 849 - 856). MIT Press.

% Idea: Introduced the normalization process of affinity matrix(D-1/2 A D-1/2), 
% eigenvectors orthonormal conversion and clustering by kmeans 

%% Compute the degree matrix
D = diag(sum(affinity,2)+eps);
n=size(affinity,1);
%% Compute the normalized laplacian / affinity matrix
%NL1 = I - D^(-1/2) .* affinity .* D^(-1/2);
for i=1:size(affinity,1)
    for j=1:size(affinity,2)
        NL1(i,j) = affinity(i,j) / (sqrt(D(i,i)) * sqrt(D(j,j)));  
    end
end
% D1 = diag( 1./sqrt(sum(affinity,2)+eps));
% NL1 = speye(n) - (D1 * affinity * D1);
if(NL1==NL1') 
    disp('Laplacian Ok')
else
    error('Laplacian not symmetric')  
end
% figure,imagesc(NL1), title('Laplacian');

%% Perform the eigen value decomposition
[eigVectors,eigValues] = eig(NL1);

%% Find the eigengap k
e = diag(eigValues);
% format long
m=length(e);
figure,
plot(e(m-49:m),'b*', 'markersize',7);
yticks([0 1]);
xlabel('Number of eigenvalues')
ylabel('Eigenvalue')
ax = gca;
ax.YAxis.FontSize = 16;
ax.XAxis.FontSize = 16;
% norm_e = (e(m-49:m)-min(e(m-49:m)))/(max(e(m-49:m))- min(e(m-49:m)));
% figure,plot((norm_e),'b*', 'markersize',7);

% k=findNumClusters(e,'eigengap')


%% Select k largest eigen vectors
k=num_clusters;
nEigVec = eigVectors(:,(size(eigVectors,1)-(k-1)): size(eigVectors,1));
% figure,plot(nEigVec,'*','Markersize',4),title('k Largest eigen vectors');
%legend 
% nEigVec;

%% Construct the normalized matrix U from the obtained eigen vectors
for i=1:size(nEigVec,1)
    n = sqrt(sum(nEigVec(i,:).^2));  
    if(n==0) 
        n=eps; 
    end
    U(i,:) = nEigVec(i,:) ./ n; 
end 

%% Perform kmeans clustering on the matrix U
[IDX,C] = kmeans(U,k);  

end

