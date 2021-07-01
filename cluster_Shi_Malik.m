function [IDX,C]=cluster_Shi_Malik(affinity,num_clusters)
% J. Shi and J. Malik,
% "Normalized Cuts and Image Segmentation",
% In Proc. IEEE Conf. Computer Vision and Pattern Recognition,
% pages 731-737, 1997.
% Idea: Introduced the use of first k generalized eigenvectors for clustering


%% Compute the degree matrix
D = diag(sum(affinity,2)+eps);
n=size(D,1);

%% Compute the unnormalized graph laplacian matrix L=D-W
L = D - affinity;
if(L==L') 
    disp('Laplacian Ok')
else
    error('Laplacian not symmetric')
end

[eigVectors,eigValues] = eig(L);
% [eigVectors,eigValues] = eig(L,D);
% e = diag(eigValues);
% figure,plot(e(1:20),'b*');
%% Select first k eigen vectors
k=num_clusters;
kEigVec = eigVectors(:,1:k);
% figure,plot(kEigVec,'*'),title('K smallest eigen vectors');
% legend

%% Perform kmeans clustering on the matrix kEigVec
[IDX,C] = kmeans(kEigVec,k);
end


%% Find the eigengap k
% format long;
% e = diag(eigValues);
% plot(e(1:20),'o');

% k=1;
% diff=[];
% for l=1:size(e,1)
%     diff(l) = round(abs(e(l+1) - e(l)),14);
%     if (diff(l)>2*mean(diff))
%         k=l;
%         break;
%     end
% end
% else
%     k=num_clusters;
% end