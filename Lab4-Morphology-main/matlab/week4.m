%% Dilation operation
A = imread('../assets/text-broken.tif');
B1 = [0 1 0;
     1 1 1;
     0 1 0];
A1 = imdilate(A, B1);
montage({A,A1})

B2 = ones(3,3);
A2 = imdilate(A, B2);

figure
montage({A, A2})
title('Dilation with 3x3 Ones SE')

% Dilation with diagonal cross
Bx = [1 0 1;
      0 1 0;
      1 0 1];

Ax = imdilate(A, Bx);

figure
montage({A, Ax})
title('Dilation with Diagonal Cross SE')

%% Structuring element
SE = strel('disk',4);
SE.Neighborhood         % print the SE neighborhood contents

%% Erosion Operation
clear all
close all

A = imread('../assets/wirebond-mask.tif');
SE2 = strel('disk',2);
SE10 = strel('disk',10);
SE20 = strel('disk',20);
E2 = imerode(A,SE2);
E10 = imerode(A,SE10);
E20 = imerode(A,SE20);

montage({A, E2, E10, E20}, "size", [2 2])

%% Morphological filtering with Open and Close
clear all
close all

% Read image
f = imread('../assets/fingerprint-noisy.tif');

% Structuring element (3x3)
SE = strel('square',3);

% Erosion
fe = imerode(f, SE);

% Dilation of eroded image
fed = imdilate(fe, SE);

% Opening
fo = imopen(f, SE);

% Display results
figure
montage({f, fe, fed, fo}, 'Size', [1 4])
title('f | fe | fed | fo')

%% Boundary Detection
clear all
close all

% Read image and convert to binary
I = imread('../assets/blobs.tif');
I = imcomplement(I);
level = graythresh(I);
BW = imbinarize(I, level);

% Morphological operation
g = bwmorph(BW, 'thin', Inf);

figure
montage({BW, g}, 'Size', [1 2])
title('Original Binary | Thinned Image')

%% Test bwmorph
%% Thinning with bwmorph

clear all
close all

%% Read image
f = imread('../assets/fingerprint.tif');

% Convert to binary
f = imcomplement(f);
level = graythresh(f);
BW = imbinarize(f, level);

% Thinning operations
g1 = bwmorph(BW, 'thin', 1);
g2 = bwmorph(BW, 'thin', 2);
g3 = bwmorph(BW, 'thin', 3);
g4 = bwmorph(BW, 'thin', 4);
g5 = bwmorph(BW, 'thin', 5);

% Display results
figure
montage({BW, g1, g2, g3, g4, g5}, 'Size', [2 3])
title('Original | Thin 1 | Thin 2 | Thin 3 | Thin 4 | Thin 5')

% Thinning until convergence
ginf = bwmorph(BW, 'thin', inf);

figure
montage({BW, ginf}, 'Size', [1 2])
title('Original | Thin (inf)')

%% Connected Components and labels
clear all
close all

t = imread('../assets/text.png');
imshow(t)
CC = bwconncomp(t)

% Determine largest component and erase
numPixels = cellfun(@numel, CC.PixelIdxList);
[biggest, idx] = max(numPixels);
t(CC.PixelIdxList{idx}) = 0;
figure
imshow(t)

%% Morphological Reconstruction
clear all
close all

f = imread('../assets/text_bw.tif');
se = ones(17,1);
g = imerode(f, se);
fo = imopen(f, se);
fr = imreconstruct(g, f);

montage({f, g, fo, fr}, "size", [2 2])

ff = imfill(f);
figure
montage({f, ff})

%% Morphological Operations on Grayscale images

clear all;
close all;

f = imread('../assets/headCT.tif');
se = strel('square',3);
gd = imdilate(f, se);
ge = imerode(f, se);
gg = gd - ge;
montage({f, gd, ge, gg}, 'size', [2 2])

clear all
close all

%% Read image
f = imread('../assets/fillings.tif');
figure; imshow(f); title('Original X-ray')

%% Improve contrast (lab style)
g = imadjust(f);
figure; imshow(g); title('After imadjust')

%% Reduce noise (lab style)
g2 = medfilt2(g, [3 3]);     % try [5 5] if still speckly
figure; imshow(g2); title('After median filter')

%% Threshold to keep only the brightest (fillings)
% Use a high threshold based on the image histogram distribution
T = prctile(g2(:), 99.5);     % try 99.3–99.8
BW = g2 > T;
figure; imshow(BW); title('Bright threshold mask')

%% Morphological cleanup (lab style)
BW = bwareaopen(BW, 80);      % remove small specks (try 50–200)
BW = imclearborder(BW);       % remove objects touching borders (common noise)

SE = strel('disk', 2);
BW = imclose(BW, SE);         % connect gaps
BW = imfill(BW, 'holes');     % fill holes
figure; imshow(BW); title('Cleaned mask')

%% Connected components and pixel sizes (lab style)
CC = bwconncomp(BW);
numPixels = cellfun(@numel, CC.PixelIdxList);

% Keep only the 2 largest components (the two fillings)
[numPixelsSorted, idx] = sort(numPixels, 'descend');

numFillings = min(2, numel(numPixelsSorted));
fillSizes = numPixelsSorted(1:numFillings);

fprintf('Number of fillings detected: %d\n', numFillings);
fprintf('Filling sizes (pixels):\n');
disp(fillSizes');
