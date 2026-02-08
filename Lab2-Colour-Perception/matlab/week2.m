%% Image information
imfinfo('peppers.png')

%% RGB
RGB = imread('peppers.png');  
imshow(RGB)

%% Greyscale image
I = rgb2gray(RGB);
figure
imshow(I)

%% Montage with title
figure
imshowpair(RGB, I, 'montage')
title('Original colour image (left) grayscale image (right)');

%% Split into Red, Green and Blue
figure
[R,G,B] = imsplit(RGB);
montage({R, G, B},'Size',[1 3])

%% Convert RGB to HSV
figure
HSV = rgb2hsv(RGB);
[H,S,V] = imsplit(HSV);
montage({H,S,V}, 'Size', [1 3])