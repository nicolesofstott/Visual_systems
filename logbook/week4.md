# Week 4 Tutorial: Morphological Image Processing  

**Date:** 05/02/2026  
**Script:** `/Users/nicolestott/Documents/GitHub/Visual_systems/Lab4-Morphology-main/matlab/week4.m`

---

## Task 1 — Dilation  

I explored dilation on a broken text image using different structuring elements.

```matlab
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
```

Observations and reflections:

- The cross-shaped SE (B1) tended to expand features mainly in vertical/horizontal directions, which helped reconnect some broken strokes but didn’t strengthen diagonals much.
- The full 3×3 ones SE (B2) produced slightly stronger thickening and filled gaps more aggressively, but it also risked merging nearby letters or closing holes inside characters.
- The diagonal cross SE (Bx) strengthened diagonal connectivity, which made it useful for slanted strokes but less effective for vertical breaks.

This was my first clear example that the structuring element is basically a shape rule. Dilation is multiple effects controlled by the SE. Choosing the SE is essentially deciding what counts as local neighbourhood structure.

```matlab
%% Structuring element
SE = strel('disk',4);
SE.Neighborhood
```

- strel returns a structuring element object rather than a raw matrix.

Seeing SE.Neighborhood helped me understand that even smooth shapes like disks are still represented as grids. This reinforced that morphology is pixel neighbourhood based, even when we think of structuring elements as smooth geometric shapes.

## Task 2 - Erosion

```matlab
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
```

Observations and reflections:

- Small erosion removed fine noise and shrank objects slightly.
- Larger erosions quickly removed thin features entirely and separated areas that were previously connected.
- At radius 20, the erosion was so aggressive that only the most robust regions remained.

An object survives only if the structuring element can fit entirely inside it. This made me realise why erosion is useful for removing small bright artifacts and why it can destroy fragile features very easily.

## Task 3 - Morphological filtering

```matlab
%% Morphological filtering with Open and Close
clear all
close all

f = imread('../assets/fingerprint-noisy.tif');

SE = strel('square',3);

fe = imerode(f, SE);
fed = imdilate(fe, SE);

fo = imopen(f, SE);

figure
montage({f, fe, fed, fo}, 'Size', [1 4])
title('f | fe | fed | fo')
```

Observations and reflections:

- Erosion removed noise but also broke some genuine ridge detail. The dilation step restored some ridge thickness, but the smallest removed elements did not return.
- imopen matched the manual erosion+dilation result, confirming the definition of opening.

Opening behaved like a shape-based denoiser, it removes small bright features that don’t match the SE while preserving larger structures. However, it also showed that morphology can remove information permanently, it can delete features depending on scale.

## Task 4 - Boundary detection

```matlab
%% Boundary Detection
clear all
close all

I = imread('../assets/blobs.tif');
I = imcomplement(I);
level = graythresh(I);
BW = imbinarize(I, level);

g = bwmorph(BW, 'thin', Inf);

figure
montage({BW, g}, 'Size', [1 2])
title('Original Binary | Thinned Image')
```
Observations and reflections:

- Graythresh worked well for separating blobs from background, but some small noise still became foreground.
- Thinning simplified shapes into skeletal structures, which made boundaries/features easier to interpret.

This task made it obvious that morphology works best when preprocessing is strong. If the binary image contains noise, morphology will often amplify it, turning blobs of noise into meaningful-looking thin lines.

## Task 5 - bwmorph thinning

```matlab
%% Thinning with bwmorph
clear all
close all

f = imread('../assets/fingerprint.tif');

f = imcomplement(f);
level = graythresh(f);
BW = imbinarize(f, level);

g1 = bwmorph(BW, 'thin', 1);
g2 = bwmorph(BW, 'thin', 2);
g3 = bwmorph(BW, 'thin', 3);
g4 = bwmorph(BW, 'thin', 4);
g5 = bwmorph(BW, 'thin', 5);

figure
montage({BW, g1, g2, g3, g4, g5}, 'Size', [2 3])
title('Original | Thin 1 | Thin 2 | Thin 3 | Thin 4 | Thin 5')

ginf = bwmorph(BW, 'thin', inf);

figure
montage({BW, ginf}, 'Size', [1 2])
title('Original | Thin (inf)')
```

Observations and reflections:

- Early thinning iterations reduced thickness while keeping ridge connectivity mostly intact.
- As iterations increased, ridge lines approached a 1-pixel skeleton.

This was a strong demonstration that more processing is not always better. Skeletonisation is useful for structure analysis, but too much thinning risks removing integrity or amplifying small errors if the input segmentation is imperfect.

## Task 6 - Connected components

```matlab
%% Connected Components and labels
clear all
close all

t = imread('../assets/text.png');
imshow(t)
CC = bwconncomp(t)

numPixels = cellfun(@numel, CC.PixelIdxList);
[biggest, idx] = max(numPixels);
t(CC.PixelIdxList{idx}) = 0;
figure
imshow(t)
```

Observations and reflections:

- bwconncomp produces a data structure that makes object-level analysis much easier than manual scanning.
- The largest connected component was removed effectively by indexing into PixelIdxList.

This task changed how I think about binary images. I realised that once binarised, you can stop thinking pixel-by-pixel and start thinking in terms of regions and components.

## Task 7 - Morphological Reconstruction

```matlab
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
```

Observations and reflections:

- Standard opening removed many features and did not accurately restore the shapes that remained.
- Reconstruction restored surviving structures better, keeping the original character shapes where the marker survived.
- imfill closed internal holes, making letters like “O” and “A” behave differently visually.

This exercise clarified the importance of reconstruction. Opening removes features based solely on size and shape relative to the structuring element, which can distort surviving components. Reconstruction restores eroded regions in a controlled manner, preserving their original form. This demonstrates that morphology can be used not only to filter but also to recover meaningful structures.

## Task 8 - Morphology on Grayscale

```matlab
%% Morphological Operations on Grayscale images
clear all;
close all;

f = imread('../assets/headCT.tif');
se = strel('square',3);
gd = imdilate(f, se);
ge = imerode(f, se);
gg = gd - ge;

montage({f, gd, ge, gg}, 'size', [2 2])
```
Observations and reflections:

- Dilation made bright regions expand.
- Erosion made dark regions expand.
- The difference (gd - ge) emphasised local intensity differences.

I found it interesting that morphology still works in grayscale, but the interpretation shifts and instead of adding/removing white pixels, it manipulates local intensity extremes. The gradient result felt like a structural edge detector built from max/min neighbourhood behaviour rather than derivatives.