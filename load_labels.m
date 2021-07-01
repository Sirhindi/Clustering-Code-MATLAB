function labels=load_labels(dir_path,dim)
 folder=dir_path;
 ext='bmp';
 names=dir([folder filesep '*.' ext]);
 labels=[];
 for i=1:length(names)
    [filepath,name,ext]=fileparts([folder filesep names(i).name]);
    inp=imread([filepath filesep name ext]);
    inp=inp(:,:,1);
    inp=imresize(inp, dim);
%     inp=imresize(inp, dim,'nearest');
%   figure, imshow(inp)
    [data_x,data_y]=find(inp);
    temp=[data_y data_x zeros(size(data_x,1),1)];
    temp(:,3)=i;
    labels = [labels;temp];
 end
%  figure, plot(labels(:,2),labels(:,1),'r.','Markersize',7);

end