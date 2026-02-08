%% Importing an image
clear all
imfinfo('../assets/breastXray.tif')
f = imread('../assets/breastXray.tif');
imshow(f)

%% Check the dimensions of f
f(3,10)
imshow(f(1:241,:)) % Show only top half

imshow(f(:, round(end/2)+1:end)) % Show only right half

% Minimum and maximum intensities
[fmin, fmax] = bounds(f(:))

%% Negative image
g1 = imadjust(f, [0 1], [1 0])
figure
montage({f, g1})

% Gamma correction
g2 = imadjust(f, [0.5 0.75], [0 1]);
g3 = imadjust(f, [ ], [ ], 2);
figure
montage({g2,g3})

%% Contrast stretching transformation
clear all
close all
f = imread('../assets/bonescan-front.tif');
r = double(f);
k = mean2(r);
E = 0.9;
s = 1 ./ (1.0 + (k ./ (r + eps)) .^ E);
g = uint8(255*s);
imshowpair(f, g, "montage")

%% Contrast enhacement using histogram
clear all
close all
f=imread('../assets/pollen.tif');
imshow(f)
figure
imhist(f);

% Stretch intensity
close all
g=imadjust(f,[0.3 0.55]);
montage({f, g})
figure
imhist(g);

% PDF and CDF
g_pdf = imhist(g) ./ numel(g);
g_cdf = cumsum(g_pdf);
close all
imshow(g);
subplot(1,2,1)
plot(g_pdf)
subplot(1,2,2)
plot(g_cdf)

% Histogram equalisation
x = linspace(0, 1, 256);
figure
plot(x, g_cdf)
axis([0 1 0 1])
set(gca, 'xtick', 0:0.2:1)
set(gca, 'ytick', 0:0.2:1)
xlabel('Input intensity values', 'fontsize', 9)
ylabel('Output intensity values', 'fontsize', 9)
title('Transformation function', 'fontsize', 12)

% Plots of all three images
h = histeq(g,256);
close all
montage({f, g, h})
figure;
subplot(1,3,1); imhist(f);
subplot(1,3,2); imhist(g);
subplot(1,3,3); imhist(h);

%% Noise-reduction with low pass filter
clear all
close all
f = imread('../assets/noisyPCB.jpg');
imshow(f)

% Box and Gaussian filters
w_box = fspecial('average', [9 9])
w_gauss = fspecial('Gaussian', [7 7], 1.0)

% Apply filters
g_box = imfilter(f, w_box, 0);
g_gauss = imfilter(f, w_gauss, 0);
figure
montage({f, g_box, g_gauss})

%% Median filtering
g_median = medfilt2(f, [7 7], 'zero');
figure; montage({f, g_median})