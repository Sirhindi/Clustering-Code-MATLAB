%%%%% November 2019 
%%%%% Spectral clustering demo using centroid, hierarchical, spectral 
%%%%% and density-based algorithms.
close all
clc
clear all

%% Load Debye-Scherrer image data
dim=[200 200];    %512, 128, 64
images={'Max1' 'Si12' 'LaB6' 'Tilted'};
algos={'kmeans' 'hc-comp' 'hc-sng' 'hc-avg' 'sc' 'sc-shi' 'sc-njw' 'dbscan'};

% [D]=load_deb_data('LaB6_0021',dim);
% [D]=load_deb_data('max1',dim);
% [D]=load_deb_data('tilted_001',dim);
% [D]=load_deb_data('Si12_0000',dim);

%% Load true labels
true_labels = load_labels('./Data_Debye/Ground Truth/Si12_0000',dim);
D=true_labels(:,1:2);

%% Noise-removal for HC-Single
% I=imread('Si12_0000.tif');
% I_bin=pre_process(I);
% I_deb_bin=imresize(I_bin,[200 200]);
% CC = bwconncomp(I_deb_bin);
% numPixels = cellfun(@numel,CC.PixelIdxList);
% %[biggest, idx] = max(numPixels);
% perc=prctile(numPixels,[50 75 85 90],'all');
% idx = find(numPixels<=perc(1));
% for r=1:size(idx,2)
%     I_deb_bin(CC.PixelIdxList{idx(r)}) = 0;
% end
% % figure, imshow(I_deb_bin);
% [x,y] = find(I_deb_bin);
% D = [y x];

%% Plot ground truth 
% plot_clustering_results(true_labels(:,3),7,D)

%% Plot data
figure,
axis off
axis equal
hold on
plot(D(:,1),D(:,2),'b.','markersize',7)
hold off

% initialize time, nmi, ri, ari arrays for runs
t=[];
z=[];
ri=[];
ari=[];
n=1;

%% Set number of clusters k
k_l=14;  %4;
k_m=7;  %38,31;
k_s=6;  %43,44; 
k_t=10; %11;

for i=1:n
%     for k_m=4:4:20
%         for sigma=0.2:0.4:1.8
tic
%% Run spectral clustering to get cluster labels
%   labels = spectral_clustering( data,4,1.0,'njw','full',10,4);
%   labels = spectral_clustering( D,k_l,0.3,'njw','full');
%   labels = spectral_clustering(D,k_m,0.6,'njw','full');
%   labels = spectral_clustering(D,k_s,0.8,'njw','full');
%   labels = spectral_clustering(D,k_t,1.5,'njw','full');

%% DBSCAN(data, epsilon, minpts) 
%    for e=0.5:3.5
%        for m=1:2:7 
%        labels=DBSCAN(D,5,3);
%        k_s=max(labels);

%% Kmeans
%     labels=kmeans(D,k_l,'EmptyAction','singleton');
 
% %% Agglomerative
%     d=pdist(D,'euclidean');
%     l=linkage(d,'single');
%     labels=cluster(l,'maxclust',k_s);

t(i)=toc;

%% Show clusters in figure and save results 
% plot_clustering_results(labels,k_l,D);
% exportgraphics(gcf,['./Png Results/' algos{7} '_' images{4} '.png'], 'resolution', 72);
% exportgraphics(gcf,['./Png Results/Fig13/' algos{7} '_cg_' images{3} '.png'], 'resolution', 72);
% close all

% figure,
% bar(sort(histcounts(labels),'descend'),0.8,'FaceColor',[0.4 0.6 0.9]);
% xlabel('Number of clusters')
% ylabel('Cluster cardinality')
% ax = gca;
% ax.YAxis.FontSize = 16;
% ax.XAxis.FontSize = 16;


%% Evaulate clusters using IED criteria
%     im_size=[dim,dim];
%     [cl_ang(i,:),avg_dist(i,:)] = evaluateClusteringResults(labels,D_S,k_s,im_size);
%     mean(cl_ang(i,:))
%     mean(avg_dist(i,:))

%% Evaluate using NMI
      z(i) = nmi(true_labels(:,3), labels);

%% Evaluate using RI and ARI
      ri(i) = rand_index(true_labels(:,3), labels);
      ari(i) = rand_index(true_labels(:,3), labels, 'adjusted');       
   
%          end
%      end
end



%% Calculate quantitative mean and std. dev values
mean_t=mean(t);
std_t=std(t);
mean_nmi=mean(z);
std_nmi=std(z);
mean_ri=mean(ri);
std_ri=std(ri);
mean_ari=mean(ari);
std_ari=std(ari);
%
disp(['Mean time for ',num2str(n),' runs is ',num2str(mean_t),' seconds']);
disp(['Standard deviation for ',num2str(i),' runs is ',num2str(std_t),' seconds']);
%
disp(['Mean NMI for ',num2str(n),' runs is ',num2str(mean_nmi)]);
disp(['Standard deviation for ',num2str(i),' runs is ',num2str(std_nmi)]);
%
disp(['Mean RI for ',num2str(n),' runs is ',num2str(mean_ri)]);
disp(['Standard deviation for ',num2str(i),' runs is ',num2str(std_ri)]);
%
disp(['Mean ARI for ',num2str(i),' runs is ',num2str(mean_ari)]);
disp(['Standard deviation for ',num2str(i),' runs is ',num2str(std_ari)]);












%% Find accuracy for random and deterministic algorithms
  %j(i,:)= jaccard(labels,true_labels(:,3))
        %  jaccard(A,B) = TP / (TP + FP + FN)

% %% Check accuracy for random algorithms
%         if (ari(i)>=0.5)
%             count_good=count_good+1;
%         else
%             count_bad=count_bad+1;
%         end

% disp(['Good detections: ', num2str((count_good/n)*100)]);
% disp(['Bad detections: ', num2str((count_bad/n)*100)]);

% figure, 
% plot_quant_results(n,z,ri,ari,t)
% saveas(gcf,['resultTilted_hier_comp_quant_results' num2str(dim)],'epsc')
