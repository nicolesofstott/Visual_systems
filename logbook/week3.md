# Week 3 Tutorial: Intensity Transformation and Spatial Filtering  

**Date:** 29/01/2026  
**Script:** `/Users/nicolestott/Documents/GitHub/Visual_systems/Lab3-Intensity-transformation-main/matlab/week3.m`

---

## Summary  

This lab explored how image quality can be improved through intensity transformations and spatial filtering. Across the tasks, I noticed a consistent trade-off, techniques that improve visibility or reduce noise often also reduce detail so selecting parameters is always a balance between clarity and information loss.

---

## Task 1 — Contrast enhancement with `imadjust`  

I imported `breastXray.tif` and inspected pixel values and intensity range.

```matlab
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
```

Observations and reflections:
Slicing the matrix made it easier to connect image regions to matrix indices, which helped me understand better that the image is fundamentally an array. The min/max intensity values were not necessarily using the full range, which explained why the X-ray looked visually flat. I realised contrast isn’t just about making an image brighter, if you expand the meaningful intensity range, subtle differences become detectable.

## Negative image
```matlab
%% Negative image
g1 = imadjust(f, [0 1], [1 0])
figure
montage({f, g1})
````
Observations and reflections:
Inverting the intensities made structures easier to pick out because bright regions turned dark and vice versa. This highlighted that perceived visibility depends on contrast relationships, a simple inversion can reveal structures that were previously masked by high brightness dominance.

## Gamma correction

```matlab
% Gamma correction
g2 = imadjust(f, [0.5 0.75], [0 1]);
g3 = imadjust(f, [ ], [ ], 2);
figure
montage({g2,g3})
```
Observations and reflections:
- g2 made a specific intensity band much clearer but some details outside the chosen range were lost.
- g3 enhanced visibility sloghlty less, but the image retained a more natural global intensity structure.

This made the difference between range remapping and nonlinear intensity shaping clearer.
Windowing is powerful but can throw away information outside the band.
Gamma can enhance without fully discarding other intensities, so it often preserves more detail overall.

## Task 2 - Contrast stretching transformation

```matlab
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
````

Observations and reflections:
Compared to imadjust, this method felt more adaptive because it’s shaped around the image’s intensity statistics. Converting to double was essential because if not the transformation would be mathematically wrong.
This task helped me understand why many enhancement techniques depend on normalisation and floating-point operations. It also demonstrated that contrast enhancement is often about remapping intensity in a way that amplifies mid-range structure rather than simply stretching everything equally.

## Task 3 - Contrast enhancement

```matlab
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
````
Observations and reflections:
The original histogram was clustered in a narrow band, which matched the washed out look of the image. After imadjust, the histogram spread out and the image looked clearer but still not fully balanced. The histogram made the enhancement process less of an estimate or guess, I could see whether intensities were actually occupying more of the available range.

## PDF and CDF

```matlab
% PDF and CDF
g_pdf = imhist(g) ./ numel(g);
g_cdf = cumsum(g_pdf);

close all

figure
imshow(g);

figure
subplot(1,2,1)
plot(g_pdf)
subplot(1,2,2)
plot(g_cdf)
```

Observations and reflections:
The PDF showed how unevenly intensities were distributed while the CDF increased in steps, which visually confirmed that many intensity values were rare or unused.
Seeing the CDF as a cumulative curve clarified why it can act as a transformation function as it reassigns intensity values so the output becomes more evenly distributed.

## Histogram equalisation

```matlab
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
```
Observations and reflections: 
Histogram equalisation increased contrast strongly, but sometimes the image looked harsher or noisier. This made me aware of an important trade-off, equalisation can reveal hidden structure but it can also amplify noise and make the image less natural. It’s not always better, it depends on whether the goal is visual realism or feature visibility.

## Task 4 - Noise reduction with low-pass filters

```matlab
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
```
Observations and reflections: 
- Both filters reduced visible noise, but also softened edges.
- The box filter produced more noticeable blur and strange smoothing.
- The Gaussian filter looked smoother and less artificial, it preserves structure slightly better.

This was an important take-away: reducing noise almost always reduces detail and gaussian smoothing feels preferable because it weighs nearby pixels more naturally than the uniform averaging filter.

## Task 5 - Median filtering

```matlab
%% Median filtering
g_median = medfilt2(f, [7 7], 'zero');
figure; montage({f, g_median})
```

Observations and reflections:
The median filter reduced noise while keeping edges more intact, fine texture was still affected although sharp boundaries were less blurred.
This made it clear why median filtering is often used, it replaces pixels based on neighbourhood ordering rather than averaging, it can suppress outliers without smearing edges as much.

## Task 6 - Sharpening filters with laplacian, sobel and unsharp

```matlab
%% Sharpening the image with Laplacian, Sobel and Unsharp filters
clear all
close all

f = imread('../assets/moon.tif');
imshow(f)

% Laplacian
w_lap = fspecial('laplacian', 0.2);
g_lap = imfilter(f, w_lap, 0);
figure
montage({f, g_lap})

% Sobel
w_sobel = fspecial('sobel');
g_sobel = imfilter(f, w_sobel, 0);
figure
montage({f, g_sobel})

% Unsharp
w_unsharp = fspecial('unsharp', 0.5);
g_unsharp = imfilter(f, w_unsharp, 0);
figure
montage({f, g_unsharp})
```

Observations and reflections:
Laplacian and Sobel emphasised edges strongly making the outputs look more like “edge maps” than improved images. Unsharp masking produced a more natural sharpening effect, making craters clearer while keeping the image recognisable.

This helped separate two ideas:
Some filters are designed to detect edges (Sobel and Laplacian outputs are dominated by gradients) while Unsharp masking is designed to enhance images by boosting high-frequency details and still preserving the original structure.

## Task 7

```matlab
%% Improve contrast of lake&tree.png
clear all
close all

f = imread('../assets/lake&tree.png');
imshow(f)

g = imadjust(f);
figure
montage({f, g})
```

imadjust improved overall visibility quickly, showing that basic remapping can be effective when an image is globally under-contrasted.

```matlab
%% Find edges in circles.tif using Sobel
clear all
close all

f = imread('../assets/circles.tif');
imshow(f)

w_sobel = fspecial('sobel');
g = imfilter(f, w_sobel, 0);

figure
montage({f, g})
```

The Sobel filter highlighted boundaries but also responded to noise/texture, suggesting edge detection often needs thresholding or smoothing to isolate “true” edges.

```matlab
%% Improve lighting and colour of office.jpg
clear all
close all

f = imread('../assets/office.jpg');
imshow(f)

g = imadjust(f, [], [], 0.8);  % gamma brighten
figure
montage({f, g})
```

Gamma correction brightened the image without simply pushing everything to white, making it more useful for correcting underexposure.

## Overall reflection
This lab made it clear that enhancement is not that simple:
- Contrast boosts can reveal information but also exaggerate noise.
- Smoothing reduces noise but blurs details.
- Sharpening increases clarity but can also amplify artifacts.

The most valuable thing I learnt was learning to interpret andd understand how and why an image changes rather than treating enhancement as trial-and-error. This is directly relevant to real-world imaging problems, where the best output depends on whether the goal is visual clarity, feature detection or noise suppression.