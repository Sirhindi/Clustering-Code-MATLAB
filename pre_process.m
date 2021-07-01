function binary_img = preProcess(img)
% Input:    img contains raw image sent here just after reading from file.
% Output:   Pre-Procesed Binary Image

%   Convert gray if colored image
    if (size(img,3)>1)
        img=rgb2gray(img);
    end
    img=double(img);

%   Scale down to smaller size
    scaleCount=0;
    SCALE=1;
    r=size(img,1);
    c=size(img,2);
    while (r >= 1024 && c >= 1024)
        scaleCount = scaleCount+1;   
        c=c/2;
        r=r/2;
    end
    
    if (scaleCount > 0)
        SCALE = 1 / (2^scaleCount);
        img=imresize(img,SCALE);
    end
    
% Work on scaled-sized Image: This image is origional one just scaled to
% smaller size
    I_normImage=(img-min(img(:)))/(max(img(:))-min(img(:)))*255;  % Map all intensities to 0-255
    I_normSmooth = conv2(I_normImage,fspecial('gaussian',2,1),'same');  % Smooth Image

   [LL gD gM gX gY] = Derivative(I_normSmooth);
    ntyPercGM = quantile(gM(:),.90);         % ntyPercGM = 90th pemcentile of gradiant magnitude
    I_normSmoothGBinar = gM > ntyPercGM;    % Normalized, smoothed and gradiant Binarized Image

    
% Apply morphological operations  (dilation and thining)    
    I_dilt=bwmorph(I_normSmoothGBinar,'dilate');
    
    I_thin=bwmorph(I_dilt,'thin');          
   
    binary_img = I_thin;
    
%    [pd.LL pd.gD pd.gM pd.gX pd.gY] = Derivative(binary_img); 
end