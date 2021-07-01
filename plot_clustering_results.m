function plot_clustering_results(cluster_inds, num_clusters, data)
IDX = cluster_inds;
temp=[];
figure,
axis equal
axis off
hold on

color = [0.9 0 0.2; 0 0.3 0.6; 0.9 0.2 0.1;0.3 0.8 0.1; 1 0.5 0; 0.5 0 0.5; 0 0.7 1; ...
         0.9 0.9 0; 0 0.5 1; 0.2 0.6 0.5; 1 0 0; 0.4 0.2 0.2; 0.6 0 0.7; 0 0.6 0.7];
for j=1:num_clusters
    c = mod(j,length(color))+1;
    inds{j,1}=find(IDX==j);
%     inds{j,2}=color(c,:,:);
    temp{j,1}=length(inds{j,1});
%     temp{j,2}=color(c,:,:);
end

[~,I] = sort(cellfun(@length,inds(:,1)),'descend');
inds = inds(I,:);

for j=1:num_clusters
     c = mod(j,length(color))+1;
    if size(data,2)==2
        plot(data(cell2mat(inds(j,1)),1),data(cell2mat(inds(j,1)),2),'.','Markersize',7,'Color',color(c,:,:));
        %         plot(data(inds,1),data(inds,2),'.','Markersize',7,'Color',color(j,:,:));
        %         saveas(gcf,['Ring_' num2str(j) '.png'],'png')
    else
        plot3(data(inds,2),data(inds,1),data(inds,3),'.');
        %     scatter3(data(inds,1),data(inds,2),data(inds,3),'.');
    end
end
hold off
figure,
hold on
newdata=sortrows(temp,1,'descend');
b=bar(cell2mat(newdata(:,1)),0.8,'FaceColor','flat');
for j=1:num_clusters
    c = mod(j,length(color))+1;
    b.CData(j,:) = color(c,:,:);%cell2mat(newdata(j,2));
end
xlabel('Number of clusters')
ylabel('Cluster cardinality')
% yticks([0 400 800 1200 1600 2000 2400 2800 3200 3600]);
ax = gca;
ax.YAxis.FontSize = 16;
ax.XAxis.FontSize = 16;
hold off

end